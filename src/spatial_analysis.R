# TODO: 
# create aggregates of Census tracts
library(tidycensus)
library(purrr)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)
library(forcats)
library(yaml)

library(leaflet)
library(sf)
library(ggplot2)

library(igraph)

options(tigris_use_cache = TRUE)

sf_to_graph <- function(data) {
  data <- data %>% filter(gay == 1)
  
  data %>% 
    st_touches(data, sparse = TRUE) %>%
    graph_from_adj_list(mode = "all") %>%
    set_vertex_attr("GEOID", value = data$GEOID) %>%
    set_vertex_attr("tract", value = data$tract) %>%
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


gaycities_geocoded_all <- read_csv("data/gaybars/gaycities/gaycities_geocoded_all.csv")

leaflet(gaycities_geocoded_all) %>%
  addTiles() %>%
  addMarkers(popup = ~name)

# get geographic census data. test on Seattle first ----

# repeat code from census_get_data.R

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
  data %>% left_join(cities, by = c("state", "county"))
}

# there are 76 counties across 33 states in the data

keys <- yaml.load_file("src/census.yml")
census_api_key(keys$census_key)

filter(states_and_counties, state == "53")

# TODO: understand caching options for shapefiles
options(tigris_use_cache = TRUE)

seattle <- 
  get_acs("tract", table = "B01003", state = "53", county = "033",
          year = "2010", survey = "acs5", geometry = TRUE)

seattle

leaflet(seattle) %>%
  addTiles() %>%
  addPolygons()

seattle_gay <- 
  seattle %>%
  left_join(bars_per_tract, by = "GEOID") %>%
  mutate(bars = ifelse(is.na(bars), 0, bars),
         state = str_sub(GEOID, 1, 2), 
         county = str_sub(GEOID, 3, 5), 
         tract = str_sub(GEOID, 6, -1), 
         gay = ifelse(bars > 0, 1, 0)) %>%
  left_join(cities, by = c("state", "county"))

seattle_bars <- gaycities_geocoded_all %>% filter(city == "Seattle")

seattle_gay %>%
  filter(gay == 1) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~tract) %>%
  addMarkers(data = seattle_bars, label = ~name, popup = ~address)

seattle_gay_only <- seattle_gay %>% filter(gay == 1)

# this is pretty effective:
# includes self:
test <- st_intersects(seattle_gay_only$geometry, seattle_gay_only$geometry, sparse=TRUE)

# excludes self:
test2 <- st_touches(seattle_gay_only$geometry, seattle_gay_only$geometry)

st_touches(seattle_gay_only$geometry, seattle_gay_only$geometry, sparse = FALSE) %>%
  igraph::graph_from_adjacency_matrix(mode = "undirected") %>%
  plot()

test_geometry <- seattle_gay_only$geometry
names(test_geometry) <- seattle_gay_only$tract

st_touches(test_geometry, test_geometry, sparse = TRUE) %>%
  graph_from_adj_list(mode = "all") %>%
  set_vertex_attr("GEOID", value = seattle_gay_only$GEOID) %>%
  set_vertex_attr("tract", value = seattle_gay_only$tract) %>%
  plot(vertex.label = V(.)$tract)


g <- 
  st_touches(seattle_gay_only, seattle_gay_only, sparse = TRUE) %>%
  graph_from_adj_list(mode = "all") %>%
  set_vertex_attr("GEOID", value = seattle_gay_only$GEOID) %>%
  set_vertex_attr("tract", value = seattle_gay_only$tract)

plot(g, vertex.label = V(g)$tract)
components(g)

# how to turn into a data frame or set of columns?

# if csize == 1 & bars == 1, then drop from gay
# group_by(membership)

df1 <- data_frame(GEOID = V(g)$GEOID, 
                  component = components(g)$membership)
df2 <- data_frame(csize = components(g)$csize) %>% rowid_to_column(var = "component")

df3 <- left_join(df1, df2, by = "component")

test <- 
  seattle_gay_only %>%
  left_join(df3, by = "GEOID") %>%
  group_by(state, county, city, component, variable) %>%
  summarise(estimate = sum(estimate), 
            moe = moe_sum(moe),
            bars = sum(bars)) %>%
  ungroup() 

# TODO: figure out caching geometries
# (would like to save to a sensible directory...)

# TODO: compare value to 2015
# (just read in and filter values; merge d3)
merged_proportion_data <- 
  read_csv("data/census/merged_proportion_data.csv", 
           col_types = list(
             estimate = col_double(),
             summary_est = col_double(),
             moe = col_double(), 
             summary_moe = col_double()
           ))
merged_count_data <- 
  read_csv("data/census/merged_count_data.csv", 
           col_types = list(
             moe = col_double()
           ))

df3

seattle_gay_prop <- 
  merged_proportion_data %>%
  filter(GEOID %in% df3$GEOID)

seattle_gay_count <- 
  merged_count_data %>%
  filter(GEOID %in% df3$GEOID)

# "bars" isn't right, bc this uses the wrong geocoded bars...
# it isn't right to sum a median income or rent, either...
# need to take (weighted) average or something...
seattle_gay_count %>%
  left_join(df3, by = "GEOID") %>%
  left_join(cities, by = c("state", "county")) %>%
  group_by(state, county, city, component, variable, year) %>%
  summarise(estimate = sum(estimate), 
            moe = moe_sum(moe),
            bars = sum(bars)) %>%
  ungroup()

vars_economic <- 
  c("B19013_001", "B25105_001", "B25064_001", "B25077_001")

seattle_gay_count %>%
  filter(variable %in% vars_economic) %>%
  left_join(df3, by = "GEOID") %>%
  left_join(cities, by = c("state", "county")) %>%
  group_by(state, county, city, component, variable, year) %>%
  summarise(estimate = mean(estimate), 
            moe = moe_sum(moe),
            bars = sum(bars)) %>%
  ungroup()

# for proportion
test_prop <- 
  seattle_gay_prop %>%
  left_join(df3, by = "GEOID") %>%
  left_join(cities, by = c("state", "county")) %>%
  group_by(state, county, city, component, variable, year) %>%
  summarise(estimate = sum(estimate), 
            moe = moe_sum(moe),
            summary_est = sum(summary_est), 
            summary_moe = moe_sum(moe),
            bars = sum(bars)) %>%
  mutate(prop = estimate/summary_est, 
         prop_moe = moe_prop(estimate, summary_est, moe, summary_moe)) %>%
  ungroup()

test_prop_filtered <-
  test_prop %>%
  filter(variable %in% c("B01001_002", "B03002_003", "B11001_003"))

test_prop_filtered %>%
  spread(variable, prop) 
ggplot(test_prop_filtered, 
       aes(x = year, y = prop, color = variable)) + 
  geom_point() + 
  facet_wrap(~component)

test_prop_filtered_wide <- 
  test_prop_filtered %>%
  select(variable, prop, year, component) %>%
  spread(key = variable, value = prop)

test_prop_filtered_wide %>%
  ggplot(aes(x = B03002_003, y = B01001_002, color = as.factor(component))) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.125, "inches"), type = "closed")) +
  ggtitle("White (X) vs Male (Y)")

test_prop_filtered_wide %>%
  ggplot(aes(x = B03002_003, y = B11001_003, color = as.factor(component))) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.125, "inches"), type = "closed")) +
  ggtitle("White (X) vs Different-sex married (Y)")

# are proportions good measures of flux, though?
# if you look at increases in numbers, they all go up...

# (All of this will involve collecting or recollecting data... or maybe not?)
# (maybe do again requesting geometries? or only do geometries for total population?)

# TODO: get different variables

# TODO: make plots

# TODO: try on different city (Chicago?)

chicago <- 
  get_acs("tract", table = "B01003", state = "17", county = c("031", "197"),
          year = "2010", survey = "acs5", geometry = TRUE)

plot(chicago)

chicago_bars <- gaycities_geocoded_all %>% filter(city == "Chicago")
chicago <- 
  chicago %>% 
  join_bars() %>%
  join_cities() 

chicago %>%
  filter(gay == 1) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~tract) %>%
  addMarkers(data = chicago_bars, label = ~name, popup = ~description)

g_chicago <- sf_to_graph(chicago)

c_chicago <- graph_to_components(g_chicago)

chicago %>%
  filter(gay == 1) %>%
  left_join(c_chicago, by = "GEOID") %>%
  group_by(state, county, city, component, csize, variable) %>%
  summarise(estimate = sum(estimate), 
            moe = moe_sum(moe),
            bars = sum(bars)) %>%
  ungroup() %>%
  filter(csize > 2) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~as.character(component))

# how many bars are in each cluster size?
c_chicago %>% 
  left_join(bars_per_tract, by = "GEOID") %>% 
  group_by(csize) %>% 
  summarise(bars = sum(bars))

# how many bars are in each cluster?
c_chicago %>% 
  left_join(bars_per_tract, by = "GEOID") %>% 
  group_by(component, csize) %>% 
  summarise(bars = sum(bars))

# touches makes more sense for network plots

# it always returns indices
st_touches(seattle_gay_only, seattle_gay_only)

# I do want to weight tracts by the number of gay bars...
# Or do I? Does it matter, if there's more than one tract
# maybe I only care if it's an orphan...
