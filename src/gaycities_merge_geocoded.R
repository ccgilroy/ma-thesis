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
  read_csv("data/gaybars/gaycities/gaycities_geocoded_by_coordinates.csv", 
           col_types = list(zip = col_character()))

gaycities_geocoded_manual_corrections <- 
  read_csv("data/gaybars/gaycities/gaycities_geocoded_manual_corrections.csv", 
           col_types = list(zip = col_character(), 
                            state = col_character(), 
                            GEOID = col_character()))

# merge two sets of geocoded bars
gaycities_geocoded_all <-
  gaycities_geocoded %>%
  bind_rows(gaycities_geocoded_by_coordinates) %>%
  arrange(id)

# filter and replace manual corrections
correction_ids <- gaycities_geocoded_manual_corrections$id

gaycities_geocoded_all <- 
  gaycities_geocoded_all %>%
  filter(!id %in% correction_ids) %>%
  bind_rows(gaycities_geocoded_manual_corrections) %>%
  arrange(id)

# gaycities_geocoded_all <- 
#   gaycities_geocoded_all %>%
#   mutate(lng = map_chr(str_split(coordinates, ","), ~.[1]), 
#          lat = map_chr(str_split(coordinates, ","), ~.[2]), 
#          lng = as.numeric(lng), 
#          lat = as.numeric(lat))

write_csv(gaycities_geocoded_all, 
          "data/gaybars/gaycities/gaycities_geocoded_all.csv")
