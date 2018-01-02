library(tidycensus)
library(purrr)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)
library(yaml)

# TODO: rerun this with all bars
gaycities_geocoded <- read_csv("data/gaybars/gaycities/gaycities_geocoded_all.csv")

# gaycities_geocoded <- 
#   gaycities_geocoded %>% 
#   mutate(GEOID = str_c(state, county, tract))

states_and_counties <- 
  gaycities_geocoded %>% 
  group_by(state, county) %>% 
  count()

states_and_counties_condensed <- 
  states_and_counties %>% 
  group_by(state) %>% 
  summarise(county = list(county))

keys <- yaml.load_file("src/census.yml")
census_api_key(keys$census_key)

v2015 <- load_variables(2015, "acs5", cache = TRUE)
View(v2015)
v2010 <- load_variables(2010, "acs5", cache = TRUE)

acs2015 <- get_acs("tract", variables = v, state = x, county = y, year = 2015, survey = "acs5")

acs2015 <- get_acs("tract", variables = v, state = x, county = y, year = 2010, survey = "acs5")

vars_economic <- c()
# to consider: split into separate sex, age, race and use `summary_var`
vars_demographic <- c(
  # sex
  "B01001_001", # sex by age - total
  "B01001_002", # male
  "B01001_026", # female
  "B01002_001", # median age - total
  "B01002_002", # median age - male
  "B01002_003", # median age - female
  # race
  "B03002_001", # hispanic or latino by race - total 
  "B03002_003", # nh white alone
  "B03002_004", # nh black alone
  "B03002_005", # nh american indian alaskan native alone
  "B03002_006", # nh asian alone
  "B03002_007", # nh native hawaiian pacific islander alone
  "B03002_008", # nh some other race alone
  "B03002_009", # nh two or more races
  "B03002_012", # hispanic or latino
  # population
  "B01003_001"  # total population
  # TODO: get density
  # TODO: get urban/rural flag
)
vars_household <- c(
  # families
  "B11001_001", # total (households!)
  "B11001_002", # family households
  "B11001_003", # married-couple family (different-sex!)
  "B11001_004", # other family
  "B11001_005", # family: male householder, no wife
  "B11001_006", # family, female householder, no husband
  "B11001_007", # nonfamily households
  "B11001_008", # nonfamily, householder living alone
  "B11001_009", # nonfamily, householder not living alone 
  # TODO: get family data for whites alone (suffix -A)
  # non-families
  "B11009_001", # total (households!)
  "B11009_002", # unmarried-partner households
  "B11009_003", # unmarried male householder and male partner
  "B11009_004", # male-female
  "B11009_005", # female-female
  "B11009_006", # female-male
  "B11009_007", # all other households 
  # TODO: get householder living alone BY GENDER (is this possible?)
  # Yes? Table B09019
  # this is population, not number of households
  # but it's not in the 2010 ACS...
  "B09019_001", # total
  "B09019_002", # in households
  "B09019_027", # nonfamily, householder living alone, male
  "B09019_030"  # nonfamily, householder living alone, female
)

# output can be "tidy" or "wide"
# what about summary var?

# tables: B11009, B11001, B03002, B01001, B01003

# testing ----
fips_codes %>% select(state, state_code) %>% group_by(state, state_code) %>% summarise()

test <- get_acs("tract", variables = vars_demographic, state = "53", county = "033", year = "2015", survey = "acs5")
test2 <- get_acs("tract", variables = vars_demographic, state = "53", county = "033", year = "2015", survey = "acs5", output = "wide")

test3 <- get_acs("tract", table = "B01003", state = "53", county = "033", year = "2015", survey = "acs5", keep_geo_vars = TRUE)

# this gets you area land, area water, and the TRACTCE

# https://walkerke.github.io/2017/05/tidycensus-every-tract/
# https://rpubs.com/wch/200398

# demographics ----
# table B01003: total population
b01003_2015 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B01003", state = state, county = county,
          year = "2015", survey = "acs5")
})

b01003_2010 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B01003", state = state, county = county,
          year = "2010", survey = "acs5")
})

b01001_2015 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B01001", state = state, county = county,
          year = "2015", survey = "acs5", summary_var = "B01001_001")
})

b01001_2010 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B01001", state = state, county = county,
          year = "2010", survey = "acs5", summary_var = "B01001_001")
})

b03002_2015 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B03002", state = state, county = county,
          year = "2015", survey = "acs5", summary_var = "B03002_001")
})

b03002_2010 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B03002", state = state, county = county,
          year = "2010", survey = "acs5", summary_var = "B03002_001")
})


# households ----
b11001_2015 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B11001", state = state, county = county,
          year = "2015", survey = "acs5", summary_var = "B11001_001")
})

b11001_2010 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B11001", state = state, county = county,
          year = "2010", survey = "acs5", summary_var = "B11001_001")
})

b11009_2015 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B11009", state = state, county = county,
          year = "2015", survey = "acs5", summary_var = "B11009_001")
})

b11009_2010 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", table = "B11009", state = state, county = county,
          year = "2010", survey = "acs5", summary_var = "B11009_001")
})

b25003_2015
b25003_2010

data_2015 <- 
  bind_rows(b01001_2015, b03002_2015, b11001_2015, b11009_2015) %>%
  mutate(year = "2011-2015")
data_2010 <- 
  bind_rows(b01001_2010, b03002_2010, b11001_2010, b11009_2010) %>%
  mutate(year = "2006-2010")

# economic ----
vars_economic <- 
  c("B19013_001", "B25105_001", "B25064_001", "B25077_001")

econ_2015 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", variables = vars_economic, state = state, county = county,
          year = "2015", survey = "acs5")
})

econ_2010 <- pmap_df(states_and_counties_condensed, function(state, county) {
  get_acs("tract", variables = vars_economic, state = state, county = county,
          year = "2010", survey = "acs5")
})
  

# B19013 median household income
# B25105 median monthly housing costs
# B25064 median gross rent

# join bar counts with ACS data ---- 

bars_per_tract <- 
  gaycities_geocoded %>% 
  group_by(GEOID) %>%
  count() %>%
  rename(bars = n) 

test2010 <- 
  b01003_2010 %>%
  mutate(year = "2006-2010") %>%
  left_join(bars_per_tract, by = "GEOID") %>%
  mutate(bars = ifelse(is.na(bars), 0, bars), 
         state = str_sub(GEOID, 1, 2), 
         county = str_sub(GEOID, 3, 5), 
         tract = str_sub(GEOID, 5, -1), 
         gay = ifelse(bars > 0, 1, 0)) 

test2015 <- 
  b01003_2015 %>%
  mutate(year = "2011-2015") %>%
  left_join(bars_per_tract, by = "GEOID") %>%
  mutate(bars = ifelse(is.na(bars), 0, bars), 
         state = str_sub(GEOID, 1, 2), 
         county = str_sub(GEOID, 3, 5), 
         tract = str_sub(GEOID, 5, -1), 
         gay = ifelse(bars > 0, 1, 0)) 

bind_rows(test2010, test2015) %>%
  group_by(variable, year, gay) %>%
  summarise(mean = mean(estimate), sd = sd(estimate))

merged_proportion_data <- 
  bind_rows(data_2010, data_2015) %>%
  mutate(prop = estimate/summary_est, 
         prop_moe = moe_prop(estimate, summary_est, moe, summary_moe)) %>%
  # mutate(prop = ifelse(is.nan(prop), 0, prop)) %>%
  left_join(bars_per_tract, by = "GEOID") %>%
  mutate(bars = ifelse(is.na(bars), 0, bars), 
         state = str_sub(GEOID, 1, 2), 
         county = str_sub(GEOID, 3, 5), 
         tract = str_sub(GEOID, 6, -1), 
         gay = ifelse(bars > 0, 1, 0)) 

merged_proportion_data %>%
  group_by(variable, year, gay) %>%
  summarise(mean = mean(prop, na.rm =  TRUE), sd = sd(prop, na.rm = TRUE)) %>%
  filter(variable %in% 
           c("B01001_002", "B03002_003", 
             "B11001_003", "B11009_003", "B11009_005")) %>%
  mutate(gay = ifelse(gay == 1, "gay", "non-gay")) %>%
  select(-sd) %>% 
  mutate(key = str_c(year, gay, sep = " ")) %>%
  ungroup() %>%
  select(-year, -gay) %>%
  spread(key, mean) %>%
  knitr::kable()

merged_count_data <- 
  bind_rows(
    bind_rows(b01003_2010, econ_2010) %>% mutate(year = "2006-2010"),
    bind_rows(b01003_2015, econ_2015) %>% mutate(year = "2011-2015")
  ) %>%
  left_join(bars_per_tract, by = "GEOID") %>%
  mutate(bars = ifelse(is.na(bars), 0, bars), 
         state = str_sub(GEOID, 1, 2), 
         county = str_sub(GEOID, 3, 5), 
         tract = str_sub(GEOID, 6, -1), 
         gay = ifelse(bars > 0, 1, 0)) 

merged_count_data %>%
  group_by(variable, year, gay) %>%
  summarise(mean = mean(estimate, na.rm = TRUE), sd = sd(estimate, na.rm = TRUE)) %>%
  mutate(gay = ifelse(gay == 1, "gay", "non-gay")) %>%
  select(-sd) %>% 
  mutate(key = str_c(year, gay, sep = " ")) %>%
  ungroup() %>%
  select(-year, -gay) %>%
  spread(key, mean) %>%
  knitr::kable()

write_csv(merged_proportion_data, "data/census/merged_proportion_data.csv")
write_csv(merged_count_data, "data/census/merged_count_data.csv")
