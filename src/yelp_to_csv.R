library(jsonlite)
library(magrittr)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)
library(purrr)
library(tibble)

# Data set 1 ----
# names and unique keys for each of top 100 cities searched
cities <- read_lines("data/census/top100cities.txt")
city_ids <-   
  cities %>% 
  str_replace_all(pattern = " ", replacement = "_") %>%
  str_replace_all(pattern = ",", replacement = "") %>%
  str_to_lower() 

search_cities <- 
  data_frame(search_city = cities, search_city_id = city_ids) %>%
  rowid_to_column(var = "rank")

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

total <- 
  responses %>%
  map_int("total") %>%
  data_frame(total_bars = ., search_city_id = names(.))

# requires sacrificing search information
# and information in list variables
unique_bars <- 
  businesses %>% 
  select(-search_city_id) %>% 
  select_if(function(x) !is.list(x)) %>% 
  select(-contains("url")) %>% 
  distinct()

# this will pick the larger city and keep that
unique_bars <- 
  businesses %>% 
  select(-contains("url"), -deals, -gift_certificates, -starts_with("menu")) %>%
  left_join(search_cities, by = "search_city_id") %>% 
  left_join(total, by = "search_city_id") %>%
  arrange(rank) %>%
  distinct(id, .keep_all = TRUE) %>%
  filter(location.country_code == "US")

unique_bars %>%
  mutate_if(is.list, 
            function(x) map(x, ~str_c(., collapse = ", "))) %>%
  mutate_if(is.list, 
            function(x) ifelse(lengths(x) > 0, x, NA)) %>%
  mutate_if(is.list, flatten_chr) %>%
  write_csv("data/gaybars/yelp/yelp_gaybars.csv")
