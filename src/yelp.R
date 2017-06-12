library(httr)
library(jsonlite)
library(magrittr)
library(readr)
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
    file_name <- paste0(city, ".json")
    content(r, as = "text") %>% 
      prettify() %>% 
      write_file(file.path("data", "gaybars", file_name))
  }
  
  ## return response
  r
}) -> responses 
## assign responses to object for manual inspection if necessary
