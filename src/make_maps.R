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

qual_filtered_components_labeled %>%
  leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(label = ~as.character(bars), 
              opacity = 1, fillOpacity = .5, 
              color = "#BD0026") %>%
  addCircles(data = gaycities_geocoded_all, color = "#BD0026", 
             opacity = 1, fillOpacity = .5)

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
        file = file.path(here::here(), "output/figures/chicago.png"), 
        vwidth = 496)

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
        file = file.path(here::here(), "output/figures/seattle.png"), 
        vwidth = 496)

# appendix maps ----
map_city <- function(this_city) {
  city_bars <- 
    bar_outliers %>%
    filter(city == this_city)
  
  m <- 
    qual_filtered_components_labeled %>%
    filter(city == this_city) %>%
    leaflet() %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(label = ~as.character(bars), 
                opacity = 1, fillOpacity = .5, 
                color = "#BD0026")  %>%
    addCircles(data = city_bars, color = "#BD0026",
               opacity = 1, fillOpacity = .5)
  
  m
}

map_san_francisco <- map_city("San Francisco")
map_new_york <- map_city("New York")
map_washington_dc <- map_city("Washington DC")
map_philadelphia <- map_city("Philadelphia")
map_denver <- map_city("Denver")
map_miami <- map_city("Miami")

mapshot(map_san_francisco, 
        file = file.path(here::here(), "output/figures/san_francisco.png"), 
        vwidth = 372, vheight = 372)

mapshot(map_new_york, 
        file = file.path(here::here(), "output/figures/new_york.png"), 
        vwidth = 372, vheight = 372)

mapshot(map_washington_dc, 
        file = file.path(here::here(), "output/figures/washington_dc.png"), 
        vwidth = 372, vheight = 372)

mapshot(map_philadelphia, 
        file = file.path(here::here(), "output/figures/philadelphia.png"), 
        vwidth = 372, vheight = 372)

mapshot(map_denver, 
        file = file.path(here::here(), "output/figures/denver.png"), 
        vwidth = 372, vheight = 372)

mapshot(map_miami, 
        file = file.path(here::here(), "output/figures/miami.png"), 
        vwidth = 372, vheight = 372)


# qual_filtered_components_labeled %>%
#   filter(city == "New York") %>%
#   leaflet() %>%
#   addProviderTiles("CartoDB.Positron") %>%
#   addPolygons(label = ~as.character(bars), 
#               opacity = 1, fillOpacity = .5, 
#               color = "#BD0026") 

# cities in analysis ----
included_cities <- qual_filtered_components_labeled$city %>% unique()

map_all_cities <- 
  gaycities_geocoded_all %>%
  filter(city %in% included_cities) %>%
  group_by(city) %>%
  summarise(lat = first(lat), lng = first(lng)) %>%
  leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircles(color = "#611bb8",    
             opacity = 1, fillOpacity = .5) %>%
  addLabelOnlyMarkers(label = ~as.character(city),
                      labelOptions = labelOptions(noHide = TRUE))

mapshot(map_all_cities, 
        file = file.path(here::here(), "output/figures/map_all_cities.png"), 
        vwidth = 837, vheight = 558)
  
# directional patterns ----
# `groups` comes from plot_descriptives.R
directional_patterns <- read_csv("data/census/directional_patterns.csv")

qual_filtered_components_labeled %>%
  left_join(directional_patterns, by = c("neighborhood_label", "city", "component")) %>%
  leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(label = ~str_c(neighborhood_label, ": ", gentrification), 
              opacity = 1, fillOpacity = .5, 
              color = ~colorFactor("Set1", gentrification)(gentrification))

qual_filtered_components_labeled %>%
  left_join(directional_patterns, by = c("neighborhood_label", "city", "component")) %>%
  leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(label = ~str_c(neighborhood_label, ": ", assimilation), 
              opacity = 1, fillOpacity = .5, 
              color = ~colorFactor("Set1", assimilation)(assimilation))
