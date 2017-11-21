library(jsonlite)
library(magrittr)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)
library(purrr)

# Data set 1 ----
# names and unique keys for each of top 100 cities searched
cities <- read_lines("data/census/top100cities.txt")
city_ids <-   
  cities %>% 
  str_replace_all(pattern = " ", replacement = "_") %>%
  str_replace_all(pattern = ",", replacement = "") %>%
  str_to_lower() 

search_cities <- data_frame(search_city = cities, search_city_id = city_ids)

# Data set 2 ----
# yelp businesses with keys for cities searched

# full file names to read in files
yelp_files <- list.files(path = "data/gaybars/yelp", pattern = "*.json", 
                         full.names = TRUE)

# short file names, truncated, to create object names
# these are *not* unique! cities with > 20 businesses 
# have multiple associated json objects
yelp_city_ids <- 
  list.files(path = "data/gaybars/yelp", pattern = "*.json", 
             full.names = FALSE) %>%
  str_replace("_[0-9].*", "")

responses <- 
  yelp_files %>%
  map(read_file) %>% 
  map(fromJSON) %>%
  set_names(yelp_city_ids)

businesses <- 
  responses %>%
  map("businesses") %>%
  # there are no gay bars in Lubbock, TX
  # compact() filters out NULL
  compact() %>%
  # jsonlite::flatten is designed for fixing nested data frames,
  # which tidyverse functions can't handle
  map(jsonlite::flatten) %>%
  bind_rows(.id = "search_city_id")

region <- 
  responses %>%
  map("region") 

businesses %>% 
  select(-search_city_id) %>% 
  select_if(function(x) !is.list(x)) %>% 
  select(-ends_with("url"), -starts_with("image")) %>% 
  distinct() %>% 
  dim()
