library(tidycensus)
library(purrr)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)
library(tibble)
library(forcats)
library(yaml)

library(sf)
library(leaflet)

# qualitative filtering ----
# cap cities
# cap number of clusters per city

# read in rds object
geometry_gay_components_nd_summarised <- 
  read_rds("data/census/geometry_gay_components_nd_summarised.rds")

# for instance: 
geometry_gay_components_nd_summarised %>%
  filter(city == "Atlanta") %>%
  filter(csize == max(csize))

# this just gets the largest cluster for each city
geometry_gay_components_nd_summarised %>% 
  group_by(city) %>%
  filter(bars == max(bars))

# this works too
# write a function gurl
top3_cities <- c("New York")
top3 <- 
  geometry_gay_components_nd_summarised %>% 
  filter(city %in% top3_cities) %>%
  group_by(city) %>%
  top_n(3, bars) %>%
  ungroup()

top2_cities <- c("San Francisco", "Chicago", "Los Angeles")
top2 <- 
  geometry_gay_components_nd_summarised %>% 
  filter(city %in% top2_cities) %>%
  group_by(city) %>%
  top_n(2, bars) %>%
  ungroup()

top1_cities <- c(
  "Miami", 
  "Fort Lauderdale", 
  "Washington DC",
  "San Diego",
  "Atlanta",
  "Dallas",
  "Houston",
  "Seattle",
  "Philadelphia",
  "Denver",
  "Baltimore",
  "Boston",
  "New Orleans",
  "Milwaukee",
  "St. Louis",
  "Tampa Bay",
  "Sacramento", 
  "Columbus",
  "San Antonio"
  )
top1 <- 
  geometry_gay_components_nd_summarised %>% 
  filter(city %in% top1_cities) %>%
  group_by(city) %>%
  top_n(1, bars) %>% 
  # There are two tied clusters in Boston by number of bars
  # The larger one, by number of tracts, is South End
  # The smaller is Fenway
  filter(csize == max(csize)) %>%
  ungroup()

rbind(top3, top2, top1) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~as.character(component), 
              opacity = 1, fillOpacity = .5, 
              color = ~colorBin("YlOrRd", bars)(bars)) 

qual_filtered_components <- rbind(top3, top2, top1)
write_rds(qual_filtered_components, 
          "data/census/qual_filtered_components.rds")

# ... if tie between # of bars, 
# take larger csize? (does that make sense?)
# this is only an issue in Boston
# where two of the six bars in Fenway share the same address

# get *list* of clusters that way, then take it back and filter map

# the only information necessary is the *component* itself
qual_filtered_components$component

# to remove geometry component
qual_filtered_components %>%
  as.data.frame() %>%
  select(state, city, component, csize, bars) %>%
  as_data_frame()

# label neighborhoods ----
neighborhood_labels <- tribble(
  ~component, ~neighborhood_label,
  183, "East Village",
  184, "West Village - Chelsea", 
  186, "Hell's Kitchen",
  16 , "West Hollywood",
  30 , "Alamitos Beach",
  21 , "Castro - Mission - Folsom - SOMA", 
  45 , "Polk Street",
  111, "Boystown",
  114, "Andersonville",
  40 , "Midtown",
  18 , "Hillcrest - North Park",
  56 , "Capitol Hill",
  65 , "Dupont Circle - Logan Circle - Shaw/U Street",
  67 , "Wilton Manors", 
  69 , "South Beach",
  79 , "Ybor City",
  100, "Midtown",
  134, "French Quarter - Marigny",
  136, "Mount Vernon",
  144, "South End",
  168, "Manchester Avenue - Central West End",
  217, "German Village",
  221, "Rittenhouse Square - Washington Square West",
  235, "Oak Lawn",
  236, "Montrose",
  246, "Northcentral",
  249, "Capitol Hill",
  252, "Walkers Point"
)

qual_filtered_components_labeled <- 
  qual_filtered_components %>%
  left_join(neighborhood_labels, by = "component")

write_rds(qual_filtered_components_labeled, 
          "data/census/qual_filtered_components_labeled.rds")

# filter GEOIDs by component information ----
geometry_components_strict_nd <- 
  read_csv("data/census/geometry_components_strict_nd.csv")

geometry_components_qual_filtered <- 
  geometry_components_strict_nd %>%
  filter(component %in% qual_filtered_components$component) %>%
  left_join(neighborhood_labels, by = "component")

# 146 census tracts are in these components, of 461
# or 32% of tracts
write_csv(geometry_components_qual_filtered, 
          "data/census/geometry_components_qual_filtered.csv")
