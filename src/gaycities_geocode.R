library(dplyr)
library(httr)
library(purrr)
library(readr)
library(stringr)
library(tibble)
library(tidyr)
library(yaml)

# explore data ----
gaycities_descriptions <- read_csv("data/gaybars/gaycities/gaycities.csv")
gaycities <- read_csv("data/gaybars/gaycities/gaycities_bars.csv")

gaycities <- gaycities %>% rowid_to_column(var = "id")

gaycities %>% group_by(city, neighborhood) %>% count() %>% arrange(desc(n)) 

# clean data for geocoding ----
# required fields for batch geocoding: 
# Unique ID, Street address, City, State, ZIP
batch_addresses <-
  gaycities %>%
  select(id, address) %>%
  mutate(address = str_split(address, ", "), 
         street_address = flatten_chr(map(address, ~.x[1])), 
         city_address = flatten_chr(map(address, ~tail(.x, n = 2)[1])),
         state = flatten_chr(map(address, ~tail(.x, n = 1))), 
         street_address = ifelse(state == "DC", 
                                 flatten_chr(map(address, ~str_c(.x[1], .x[2], sep = " "))), 
                                 street_address)) %>%
  filter(street_address != "Music Valley") %>%
  filter(! state %in% c("AB", "MB", "QC", "ON", "BC", "Mexico")) %>%
  select(-address) %>%
  mutate(zip = "")

set.seed(20171125)
batch_addresses_test <- batch_addresses %>% sample_n(10) 

write_csv(batch_addresses_test, 
          "data/gaybars/gaycities/batch_addresses_test.csv", 
          col_names = FALSE)

write_csv(batch_addresses, 
          "data/gaybars/gaycities/batch_addresses.csv", 
          col_names = FALSE)

# geocode data ----

geocoding_url <- "https://geocoding.geo.census.gov/geocoder/geographies/addressbatch"
query_list = list(
  benchmark = "Public_AR_Current",
  vintage = "Current_Current"
)
addressFile = upload_file("data/gaybars/gaycities/batch_addresses.csv")
r <- POST(url = geocoding_url, 
          query = query_list, 
          body = list(addressFile = addressFile))

write(content(r, as = "text", encoding = "utf-8"), 
      "data/gaybars/gaycities/geocode_results.csv")

# examine results of geocoding ----

# columns are described here: 
# https://www.census.gov/geo/maps-data/data/geocoder.html
# I have adjusted the names slightly
geocode_result_names <- c(
  "id", "address", 
  "match", "exact", "matched_address", 
  "coordinates", "tiger_line_id", "side",
  "state", "county", "tract", "block"
)

geocode_results <- 
  read_csv("data/gaybars/gaycities/geocode_results.csv", 
           col_names = geocode_result_names, 
           trim_ws = TRUE) 

failure_ids <- 
  geocode_results %>%
  arrange(id) %>%
  filter(match %in% c("Tie", "No_Match")) %>%
  .$id

# TODO: geocode ties and no-matches
gaycities_geocode_failures <- 
  gaycities %>%
  filter(id %in% failure_ids)

write_csv(gaycities_geocode_failures, 
          "data/gaybars/gaycities/gaycities_geocode_failures.csv")

# STEPS:
# get bar page [python]
# get zip code [python]
# use google maps api [python]
# send lat/long to Census [R?]

# merge geocode results with bar information ----
matched_results <- 
  geocode_results %>%
  select(-address) %>%
  filter(match == "Match")

gaycities_geocoded <- inner_join(gaycities, matched_results, by = "id")

gaycities_geocoded %>% group_by(state, county, tract) %>% count() %>% arrange(desc(n))

gaycities_geocoded %>% 
  group_by(state, county, tract) %>% 
  count() %>% 
  arrange(desc(n)) %>%
  ungroup() %>%
  group_by(n) %>%
  count() 

write_csv(gaycities_geocoded, "data/gaybars/gaycities/gaycities_geocoded.csv")
