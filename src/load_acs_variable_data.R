library(tidycensus)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)

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
             moe = col_double(), 
             tract = col_character()
           ))

# important variables ----
# TODO: add proportion college educated
variable_labels <- tribble(
  ~variable   , ~label,
  "B01001_002", "male",
  "B03002_003", "white",
  "B11001_003", "married",
  "B01003_001", "total population",
  "B19013_001", "median income",
  "B25064_001", "median rent",
  "B07009_005_006", "college educated"
)

prop_vars <- c(
  "B01001_002", # male
  "B03002_003", # nh white
  "B11001_003" # ds married
  # college-educated goes here
)

educ_vars <- c(
  "B07009_005",  # bachelors
  "B07009_006"   # graduate
)

count_vars <- c(
  "B01003_001", # total
  "B19013_001", # median hh income
  "B25064_001" # median rent 
)

educ_data <- 
  merged_proportion_data %>%
  filter(variable %in% educ_vars) %>%
  group_by(GEOID, NAME, summary_est, summary_moe, 
           year, bars, state, county, tract, gay) %>%
  summarise(estimate = sum(estimate), 
            moe = moe_sum(moe)) %>%
  mutate(variable = "B07009_005_006") %>%
  mutate(prop = estimate/summary_est, 
         prop_moe = moe_prop(estimate, summary_est, moe, summary_moe)) %>%
  ungroup()

prop_data <- 
  merged_proportion_data %>%
  filter(variable %in% prop_vars) %>%
  bind_rows(educ_data)

count_data <- 
  merged_count_data %>%
  filter(variable %in% count_vars)

# count data will have NAs for "summary_est" "summary_moe" "prop" "prop_moe" 
source("src/load_geocoded_bar_data.R")
main_data <- 
  bind_rows(proportion = prop_data, count = count_data, .id = "type") %>%
  select(-c(state, county, tract, bars, gay)) %>%
  left_join(variable_labels, by = "variable") %>%
  # TODO: decide if better to include or exclude downtowns here
  join_bars() %>%
  join_cities() %>%
  # rearrange columns
  select(GEOID, NAME, 
         state, county, tract, 
         city, 
         bars, gay, 
         year, 
         type, variable, label, 
         everything())

main_data_gay <- main_data %>% filter(gay == 1)
geometry_components_qual_filtered <- 
  read_csv("data/census/geometry_components_qual_filtered.csv")

main_data_gay_qual <- 
  main_data_gay %>%
  inner_join(geometry_components_qual_filtered, by = "GEOID") 

# model data ----
# need component information
# only use cities with gay bar components
# indicator for if component isn't NA

qual_cities <- unique(main_data_gay_qual$city)

model_data <- 
  main_data %>%
  filter(city %in% qual_cities) %>% 
  filter(!GEOID %in% c("06037137000", "06037930401")) %>%
  left_join(geometry_components_qual_filtered, by = "GEOID") 

# prepare model data
conversion_factor <- 1.08710584
usd_vars <- c("median income", "median rent")

model_data_prop <- 
  model_data %>%
  # convert to 2015 USD
  mutate(estimate = ifelse(label %in% usd_vars & year == "2006-2010", 
                           estimate*conversion_factor, estimate)) %>%
  # use props for estimates
  mutate(estimate = ifelse(is.na(prop), estimate, prop), 
         moe = ifelse(is.na(prop), moe, prop_moe)) %>%
  select(-c(summary_est, summary_moe, prop, prop_moe))

model_data_prop_wide <- 
  model_data_prop %>%
  ungroup() %>%
  select(GEOID, NAME, state, county, tract, city, bars, gay,
         label, estimate, year, component, csize, neighborhood_label) %>%
  spread(key = label, value = estimate) %>%
  rename(median_income = `median income`, 
         median_rent = `median rent`, 
         total_population = `total population`, 
         college_educated = `college educated`) %>%
  # filter(total_population > 0) %>%
  # filter out NAs
  filter_at(vars(college_educated, male, married, median_income, median_rent, 
                 total_population, white), 
            all_vars(!is.na(.)))


model_data_prop_wide_std <- 
  model_data_prop_wide %>%
  # log and scale
  mutate_at(vars(median_income, median_rent, total_population), log) 

# take logs of total pop, median income, median rent before scaling
# use scaled versions for matching

# let's assume we'll model the proportions

model_data_t1 <- 
  model_data_prop_wide %>%
  filter(year == "2006-2010") %>%
  select(-year)

model_data_t2 <- 
  model_data_prop_wide %>%
  filter(year == "2011-2015") %>%
  select(-year)

id_variables <- names(model_data_t1)[1:11]

model_data_wide <- 
  model_data_t1 %>%
  inner_join(model_data_t2, by = id_variables, 
             suffix = c("_2010", "_2015"))
