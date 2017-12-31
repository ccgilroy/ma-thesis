library(readr)
library(stringr)
library(dplyr)
library(tidyr)

gaycities_geocoded <- read_csv("data/gaybars/gaycities/gaycities_geocoded.csv")

gaycities_geocoded <- 
  gaycities_geocoded %>% 
  mutate(GEOID = str_c(state, county, tract)) %>%
  select(-c(match, exact, matched_address, tiger_line_id, side))

gaycities_geocoded_by_coordinates <- 
  read_csv("data/gaybars/gaycities/gaycities_geocoded_by_coordinates.csv")

gaycities_geocoded_all <-
  gaycities_geocoded %>%
  bind_rows(gaycities_geocoded_by_coordinates) %>%
  arrange(id)

gaycities_geocoded_all <- 
  gaycities_geocoded_all %>%
  mutate(lng = map_chr(str_split(coordinates, ","), ~.[1]), 
         lat = map_chr(str_split(coordinates, ","), ~.[2]), 
         lng = as.numeric(lng), 
         lat = as.numeric(lat))

write_csv(gaycities_geocoded_all, 
          "data/gaybars/gaycities/gaycities_geocoded_all.csv")
