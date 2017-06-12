library(httr)
library(jsonlite)
library(magrittr)
library(readr)
library(stringr)
library(yaml)

## Set up API and oauth --------------------------------------------------------

## read keys from a YAML file, which *isn't* committed to the git repo
keys <- yaml.load_file("src/yelp.yml")
consumer_key <- keys$consumer_key
consumer_secret <- keys$consumer_secret
token <- keys$token
token_secret <- keys$token_secret

myapp <- oauth_app("yelp", 
                   key = consumer_key, 
                   secret = consumer_secret)
sig <- sign_oauth1.0(myapp, token = token, token_secret = token_secret)
## this is deprecated, but it works
## to use an endpoint with oauth2, would need to use v3 
## of the yelp API, which isn't as extensive

## yelp API v2 search url
yelp_search <- "https://api.yelp.com/v2/search"

## TODO: programmatically create and read in list of cities
cities <- c("Seattle")

## Make requests ---------------------------------------------------------------

lapply(cities, function(city) {
  ## pause between API requests to avoid rate-limiting
  Sys.sleep(10)
  
  ## make request
  ## yelp_search and sig are global variables
  query_list <-
    list(
      category_filter = "gaybars", 
      location = city
    )
  r <- GET(yelp_search, sig, query = query_list)
  
  ## write response to json file
  ## only if http status is ok
  if(status_code(r) == 200) {
    file_name <-
      city %>% 
      str_replace_all(pattern = " ", replacement = "_") %>%
      str_to_lower() %>%
      str_c(".json")
    content(r, as = "text") %>% 
      prettify() %>% 
      write_file(file.path("data", "gaybars", "yelp", file_name))
    
    r_parsed <- content(r)
    
    ## Are there more than 20 listings?
    if (r_parsed$total > 20) {
      ## calculate number of offsets necessary
      max_offsets <- floor(r_parsed$total / 20) 
      
      r_offsets <- 
        lapply(1:max_offsets, function(offset) {
          ## duplicate above code, but with offset
          ## TODO: refactor this into a more elegant function
          ## function(city, offset = 0)
          
          ## pause between API requests to avoid rate-limiting
          Sys.sleep(10)
          
          ## make request
          ## yelp_search and sig are global variables
          query_list <-
            list(
              category_filter = "gaybars", 
              location = city, 
              offset = offset
            )
          r <- GET(yelp_search, sig, query = query_list)
          
          ## write response to json file
          ## only if http status is ok
          if(status_code(r) == 200) {
            file_name <-
              city %>% 
              str_replace_all(pattern = " ", replacement = "_") %>%
              str_to_lower() %>%
              str_c(offset, ".json")
            content(r, as = "text") %>% 
              prettify() %>% 
              write_file(file.path("data", "gaybars", "yelp", file_name))
          }
          
          ## return response
          r  
        })
      
      ## return list of responses
      c(list(r), r_offsets)
    } else {
      ## return single response if <= 20 listings
      r
    }
  } else {
    ## return single response if error
    r
  }
}) -> responses 
## assign responses to object for manual inspection if necessary

## save as R object for request information
saveRDS(responses, "data/gaybars/yelp/responses.rds")

## Main function for making requests -------------------------------------------
## Note presence of hard-coded values like sleep time (10), 
## category filter ("gaybars"), and the file path
## as well as globals like yelp_search and sig

make_yelp_request <- function(city, offset = 0) {
  ## pause between API requests to avoid rate-limiting
  Sys.sleep(10)
  
  ## make request
  ## yelp_search and sig are global variables
  query_list <-
    list(
      category_filter = "gaybars", 
      location = city, 
      offset = offset
    )
  r <- GET(yelp_search, sig, query = query_list)
  
  ## write response to json file
  ## only if http status is ok
  if(status_code(r) == 200) {
    file_name <-
      city %>% 
      str_replace_all(pattern = " ", replacement = "_") %>%
      str_to_lower() %>%
      str_c(offset, ".json")
    content(r, as = "text") %>% 
      prettify() %>% 
      write_file(file.path("data", "gaybars", "yelp", file_name))
  }
  
  ## return response
  r  
}
