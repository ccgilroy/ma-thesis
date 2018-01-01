library(dplyr)
library(httr)
library(jsonlite)
library(purrr)
library(readr)
library(stringr)
library(tibble)
library(tidyr)
library(yaml)

gaycities_gm_geocoded <- read_csv("data/gaybars/gaycities/gaycities_gm_geocoded.csv")

# The address of the Double Header, in Seattle, is not 407 2nd Ave
# it is half a block south in a different census tract.
# I can confirm this because I have been there
# and I have cross-checked the correct address with 
double_header <- gaycities_gm_geocoded %>% filter(name == "Double Header")
double_header$address <- "407 2nd Ave South Extension, Seattle, WA"

manual_corrections_to_recode <- 
  bind_rows(
    double_header
  )

# get lat/lng from Google Maps
gm_url = "https://maps.googleapis.com/maps/api/geocode/json"
gm_cfg = yaml.load_file("src/google_maps.yml")

gm_manual <- 
  manual_corrections_to_recode %>%
  mutate(response = map(address, function(x) {
    Sys.sleep(.5)
    params <- list(
      address = x,
      key = gm_cfg$api_key
    )
    GET(url = gm_url, query = params)
  }))

gm_manual_processed <- 
  gm_manual %>%
  mutate(status_code = map_int(response, status_code), 
         content = map(response, content),
         results = map(content, ~.$results), 
         n_results = lengths(results), 
         lat = map_chr(results, ~.[[1]]$geometry$location$lat),
         lng = map_chr(results, ~.[[1]]$geometry$location$lng)) %>%
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
         })) %>%
  mutate(zip = flatten_chr(postal_code), 
         formatted_address = flatten_chr(formatted_address))

vars_to_keep <- names(manual_corrections_to_recode)

gm_manual_geocoded <- gm_manual_processed %>% select(one_of(vars_to_keep)) 

# code Census using lat / lon
census_geocode_url = "https://geocoding.geo.census.gov/geocoder/geographies/coordinates"

census_geocoded <- 
  gm_manual_geocoded %>% 
  mutate(response = map2(lng, lat, function(x, y) {
    Sys.sleep(.5)
    params <- list(
      benchmark = "Public_AR_Current",
      vintage = "Current_Current",
      x = x, 
      y = y,
      format = "json"
    )
    GET(url = census_geocode_url, query = params)
  }))

census_manual <-
  census_geocoded %>%
  rename(state_abbreviation = state) %>%
  mutate(content = map(response, ~fromJSON(content(., as = "text")))) 

census_manual <- 
  census_manual %>%
  mutate(state = map_chr(content, c("result", "geographies", "Census Tracts", "STATE")), 
         county = map_chr(content, c("result", "geographies", "Census Tracts", "COUNTY")), 
         tract = map_chr(content, c("result", "geographies", "Census Tracts", "TRACT")), 
         block = map_chr(content, c("result", "geographies", "2010 Census Blocks", "BLOCK")), 
         GEOID = map_chr(content, c("result", "geographies", "Census Tracts", "GEOID"))) %>%
  select(-c(response, content))

gaycities_geocoded_manual_corrections <- 
  census_manual %>%
  mutate(coordinates = str_c(lng, lat, sep = ","))

write_csv(gaycities_geocoded_manual_corrections, 
          "data/gaybars/gaycities/gaycities_geocoded_manual_corrections.csv")
