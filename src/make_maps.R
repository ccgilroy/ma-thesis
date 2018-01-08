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
library(mapview)

source("src/load_geocoded_bar_data.R")

qual_filtered_components_labeled <- 
  read_rds("data/census/qual_filtered_components_labeled.rds")

geometry_components_qual_filtered <- 
  read_csv("data/census/geometry_components_qual_filtered.csv")

bar_outliers <- 
  gaycities_geocoded_all %>%
  filter(!GEOID %in% geometry_components_qual_filtered$GEOID)


chicago_bars <- 
  bar_outliers %>%
  filter(city == "Chicago" & city_address == "Chicago")
map_chicago <- 
  qual_filtered_components_labeled %>%
  filter(city == "Chicago") %>%
  leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(label = ~as.character(bars), 
              opacity = 1, fillOpacity = .5, 
              color = "#BD0026") %>%
  addCircles(data = chicago_bars, color = "#BD0026", 
             opacity = 1, fillOpacity = .5)


mapshot(map_chicago, 
        file = file.path(here::here(), "output/figures/chicago.png"))

# idea: only plot bars NOT in component
seattle_bars <- 
  bar_outliers %>%
  filter(city == "Seattle")
map_seattle <- 
  qual_filtered_components_labeled %>%
  filter(city == "Seattle") %>%
  leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(label = ~as.character(bars), 
              opacity = 1, fillOpacity = .5, 
              color = "#BD0026") %>%
  addCircles(data = seattle_bars, color = "#BD0026", 
             opacity = 1, fillOpacity = .5)

# experiment with vwidth and vheight to set viewport
# defaults are 992 and 744 respectively
mapshot(map_seattle, 
        file = file.path(here::here(), "output/figures/seattle.png"))
