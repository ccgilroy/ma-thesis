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
