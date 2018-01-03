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

join_cities <- function(data) {
  # filter out Long Beach because it's in the same county as LA
  # and this results in duplicated observations
  cities <- cities %>% filter(city != "Long Beach, CA")
  data %>% left_join(cities, by = c("state", "county"))
}
