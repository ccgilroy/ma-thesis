# loads and creates R objects for use in analysis
library(readr)
library(stringr)
library(dplyr)
library(tidyr)

# data ----
gaycities_geocoded_all <- 
  read_csv("data/gaybars/gaycities/gaycities_geocoded_all.csv")

states_and_counties <- 
  gaycities_geocoded_all %>% 
  group_by(state, county) %>% 
  count()

states_and_counties_condensed <- 
  states_and_counties %>% 
  group_by(state) %>% 
  summarise(county = list(county))

bars_per_tract <- 
  gaycities_geocoded_all %>% 
  group_by(GEOID) %>%
  count() %>%
  rename(bars = n) 

bars_per_tract_no_downtown <-
  gaycities_geocoded_all %>% 
  # all bars in Long Beach are classified as being "Downtown"
  # which does not appear to be accurate
  # The largest cluster is called Alamitos Beach or Broadway, 
  # and it is east of the actual downtown
  mutate(neighborhood = ifelse(city == "Long Beach, CA", NA, neighborhood)) %>%
  filter(!str_detect(neighborhood, "Downtown") | is.na(neighborhood)) %>%
  # manually filter out downtowns in Columbus and San Antonio
  # In Columbus, one census tract covers both Downtown 
  # and a tiny part of Short North. Another tract covers Downtown and 
  # overlaps with German Village.
  # In San Antonio, the downtown neighborhood is labeled "Alamo"
  filter(!GEOID %in% c("39049003000", "39049004000", "48029110100")) %>%
  group_by(GEOID) %>%
  count() %>%
  rename(bars = n) 

cities <- 
  gaycities_geocoded_all %>% 
  group_by(state, county, city) %>% 
  summarise() %>%
  ungroup()

# functions ----
join_bars <- function(data) {
  data %>% 
    left_join(bars_per_tract, by = "GEOID") %>%
    mutate(bars = ifelse(is.na(bars), 0, bars),
           state = str_sub(GEOID, 1, 2), 
           county = str_sub(GEOID, 3, 5), 
           tract = str_sub(GEOID, 6, -1), 
           gay = ifelse(bars > 0, 1, 0)) 
}

join_bars_no_downtown <- function(data) {
  data %>% 
    left_join(bars_per_tract_no_downtown, by = "GEOID") %>%
    mutate(bars = ifelse(is.na(bars), 0, bars),
           state = str_sub(GEOID, 1, 2), 
           county = str_sub(GEOID, 3, 5), 
           tract = str_sub(GEOID, 6, -1), 
           gay = ifelse(bars > 0, 1, 0)) 
}

join_cities <- function(data) {
  # filter out Long Beach because it's in the same county as LA
  # and this results in duplicated observations
  cities <- cities %>% filter(city != "Long Beach, CA")
  data %>% left_join(cities, by = c("state", "county"))
}
