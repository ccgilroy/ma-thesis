# input: geocoded gaycities bar data
# outputs: 
# csv of GEOIDs mapped to components and component sizes
# rds of 2010 tract geometries for select counties

# packages ----
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
library(sp)
library(igraph)

options(tigris_use_cache = TRUE)

# functions ----
sf_to_graph <- function(data) {
  data <- data %>% filter(gay == 1)
  
  data %>% 
    st_touches(data, sparse = TRUE) %>%
    graph_from_adj_list(mode = "all") %>%
    set_vertex_attr("GEOID", value = data$GEOID) %>%
    set_vertex_attr("state", value = data$state) %>%
    set_vertex_attr("county", value = data$county) %>%
    set_vertex_attr("tract", value = data$tract) %>%
    set_vertex_attr("city", value = data$city) %>%
    set_vertex_attr("bars", value = data$bars)
}

sf_to_graph_strict <- function(data) {
  data <- data %>% filter(gay == 1)
  
  data$geometry %>%
    as_Spatial() %>%
    over(., ., returnList = TRUE, minDimension = 1) %>%
    graph_from_adj_list(mode = "all", duplicate = FALSE) %>%
    simplify() %>%
    set_vertex_attr("GEOID", value = data$GEOID) %>%
    set_vertex_attr("state", value = data$state) %>%
    set_vertex_attr("county", value = data$county) %>%
    set_vertex_attr("tract", value = data$tract) %>%
    set_vertex_attr("city", value = data$city) %>%
    set_vertex_attr("bars", value = data$bars)
}

graph_to_components <- function(g) {
  df1 <- 
    data_frame(GEOID = V(g)$GEOID, component = components(g)$membership)
  df2 <- 
    data_frame(csize = components(g)$csize) %>% 
    rowid_to_column(var = "component")
  
  left_join(df1, df2, by = "component")    
}

# load data and census key  ----
source("src/load_geocoded_bar_data.R")

keys <- yaml.load_file("src/census.yml")
census_api_key(keys$census_key)
 
# get tract geometry for one ACS variable in 2010 ----
# B01003: total population
# must use map & reduce instead of map_df, per
# https://walkerke.github.io/2017/05/tidycensus-every-tract/

geometry_b01003_2010 <- reduce(
  pmap(states_and_counties_condensed, function(state, county) {
    get_acs("tract", table = "B01003", state = state, county = county,
            year = "2010", survey = "acs5", geometry = TRUE)
  }), rbind
)

# add bars and cities to ACS data ----
geometry_b01003_2010_bc <- 
  geometry_b01003_2010 %>%
  join_bars() %>%
  join_cities()

# save this file to rds
write_rds(geometry_b01003_2010_bc, "data/census/geometry_2010.rds")

# filter to gay tracts only ----
geometry_b01003_2010_gay <- 
  geometry_b01003_2010_bc %>% 
  filter(gay == 1)

# cluster adjacent tracts and identify components ----
geometry_graph <- sf_to_graph(geometry_b01003_2010_gay)
geometry_graph_strict <- sf_to_graph_strict(geometry_b01003_2010_gay)

geometry_components <- graph_to_components(geometry_graph)
geometry_components_strict <- graph_to_components(geometry_graph_strict)

# save components data frame
write_csv(geometry_components, "data/census/geometry_components.csv")
write_csv(geometry_components_strict, 
          "data/census/geometry_components_strict.csv")


# exploratory plots ----
library(leaflet)
geometry_b01003_2010_gay %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~tract) %>%
  addMarkers(data = gaycities_geocoded_all, label = ~name, popup = ~address)

# join components 

geometry_gay_components <- 
  geometry_b01003_2010_gay %>% 
  left_join(geometry_components_strict, by = "GEOID") 
# pal <- colorFactor("Paired", geometry_gay_components$csize)
geometry_gay_components %>%
  group_by(state, county, city, component, csize, variable) %>%
  summarise(estimate = sum(estimate), 
            moe = moe_sum(moe),
            bars = sum(bars)) %>%
  ungroup() %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~as.character(component), 
              opacity = 1, fillOpacity = .5, 
              color = ~colorBin("YlOrRd", bars)(bars)) %>%
  addMarkers(data = gaycities_geocoded_all, label = ~name, popup = ~description)

# comparison of number of bars and cluster size
geometry_gay_components %>%
  group_by(state, county, city, component, csize, variable) %>%
  summarise(estimate = sum(estimate),
  moe = moe_sum(moe),
  bars = sum(bars)) %>%
  ungroup() %>% 
  ggplot(aes(x = csize, y = bars)) + 
  geom_point(color = alpha("black", .5)) +
  theme_minimal()


# do something about downtowns
# DONE: do something about tracts that only touch in corners
# (e.g. phoenix looks really weird)

# exploratory geometry ----
geometry_b01003_2010_gay %>% 
  filter(city == "Phoenix") %>%
  select(geometry) %>%
  st_overlaps(., .)

test_phoenix <- 
  geometry_b01003_2010_gay %>% 
  filter(city == "Phoenix") %>% 
  sf_to_graph() %>%
  graph_to_components()

geometry_b01003_2010_gay %>% 
  filter(city == "Phoenix") %>%
  left_join(test_phoenix, by = "GEOID") %>%
  select(component, geometry) %>%
  plot()

g1 <- 
  geometry_b01003_2010_gay %>% 
  filter(city == "Phoenix") %>%
  sf_to_graph()

g2 <- 
  geometry_b01003_2010_gay %>% 
  filter(city == "Phoenix") %>%
  sf_to_graph_strict()

