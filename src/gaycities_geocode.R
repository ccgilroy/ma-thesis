library(dplyr)
library(httr)
library(jsonlite)
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

# get zip codes from google maps ----
gm_addresses <- 
  batch_addresses %>%
  mutate(address = str_c(street_address, city_address, sep = ", "), 
         address = str_c(address, state, sep = " "))

gm_url = "https://maps.googleapis.com/maps/api/geocode/json"
gm_cfg = yaml.load_file("src/google_maps.yml")

gm_addresses_geocoded <- 
  gm_addresses %>%
  mutate(response = map(address, function(x) {
    Sys.sleep(.5)
    params <- list(
      address = x,
      key = gm_cfg$api_key
    )
    GET(url = gm_url, query = params)
  }))

# TODO: what if more than one result?

gm_addresses_processed <- 
  gm_addresses_geocoded %>%
  mutate(status_code = map_int(response, status_code), 
         content = map(response, content),
         results = map(content, ~.$results), 
         n_results = lengths(results), 
         # formatted_address = map_chr(results, ~.[[1]]$formatted_address),
         lat = map_chr(results, ~.[[1]]$geometry$location$lat),
         lng = map_chr(results, ~.[[1]]$geometry$location$lng))

# 831 with 1 result, 7 with 2 results, 2 with 3 results

gm_addresses_processed <- 
  gm_addresses_processed %>%
  mutate(content_as_text = map(response, ~content(., as = "text")), 
         formatted_address = map(content_as_text, function(x) {
           fromJSON(x)$results$formatted_address
         }),
         postal_code = map(content_as_text, function(x) {
           fromJSON(x) %>%
             .$results %>% 
             select(address_components) %>%
             flatten_df() %>%
             as_data_frame() %>%
             mutate(type = map_chr(types, ~.[[1]])) %>%
             filter(type == "postal_code") %>%
             .$long_name
         }), 
         location = map(content_as_text, function(x) {
           fromJSON(x)$results$geometry$location
         }))

gm_single_address <- 
  gm_addresses_processed %>% 
  filter(n_results == 1) %>%
  mutate(zip = flatten_chr(postal_code), 
         formatted_address = flatten_chr(formatted_address))

gm_multiple_addresses <- gm_addresses_processed %>% filter(n_results > 1)

# at this point I manually checked addresses and urls (where possible)
# for these 9 bars
# Atlanta: 2nd (30307)
# Atlanta: 1st (30316)
# Boston: 1st (02111)
# Cincinnati: 2nd (45202)
# Denver: 2nd (80204)
# Honolulu: 1st (96815)
# Las Vegas: 1st (89109)
# New York: 1st (10011)
# Salt Lake City: 2nd(84190)
ix <- c(2, 1, 1, 2, 2, 1, 1, 1, 2)

gm_multiple_addresses <-
  gm_multiple_addresses %>%
  mutate(i = ix) %>%
  mutate(zip = map2_chr(postal_code, i, ~.x[[.y]]), 
         formatted_address = map2_chr(formatted_address, i, ~.x[[.y]]), 
         lat = map2_chr(location, i, ~.x$lat[[.y]]), 
         lng = map2_chr(location, i, ~.x$lat[[.y]]))

vars_to_keep <- c("id", "street_address", "city_address", "state", "zip", 
                  "n_results", "formatted_address", "lat", "lng")
gm_geocoded <- 
  bind_rows(
    select(gm_single_address, one_of(vars_to_keep)),
    select(gm_multiple_addresses, one_of(vars_to_keep))
  ) %>%
  arrange(id)

# write Google Maps geocoding results to file ----
gaycities_gm_geocoded <- 
  gaycities %>%
  inner_join(gm_geocoded, by = "id")

write_csv(gaycities_gm_geocoded, 
          "data/gaybars/gaycities/gaycities_gm_geocoded.csv")

# write batch addresses to file ----
batch_addresses <- 
  gm_geocoded %>%
  select(id, street_address, city_address, state, zip)

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
  gaycities_gm_geocoded %>%
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

gaycities_geocoded <- 
  gaycities_gm_geocoded %>%
  rename(state_abbrevation = state) %>%
  inner_join(matched_results, by = "id")

gaycities_geocoded %>% group_by(state, county, tract) %>% count() %>% arrange(desc(n))

gaycities_geocoded %>% 
  group_by(state, county, tract) %>% 
  count() %>% 
  arrange(desc(n)) %>%
  ungroup() %>%
  group_by(n) %>%
  count() 

write_csv(gaycities_geocoded, "data/gaybars/gaycities/gaycities_geocoded.csv")
