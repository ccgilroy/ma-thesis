library(readr)
library(stringr)
library(dplyr)
library(tidyr)
library(tibble)
library(forcats)

# population density ----
# population density is total population (B01003) divided by area land (ALAND)
# https://medium.com/@mbostock/command-line-cartography-part-2-c3a82c5c0f3
# 2589975.2356 would be the conversion factor between square meters and square miles
# rather than downloading all of the shapefiles and calculating this, 
# population densities were downloaded manually from 
# https://www.socialexplorer.com/tables/ACS2010_5yr/R11688797
# https://www.socialexplorer.com/tables/ACS2015_5yr/R11688823
# the University of Washington has a professional license for Social Explorer

acs2010_t002 <- read_csv("data/census/socialexplorer/R11688797_SL140.csv")
acs2015_t002 <- read_csv("data/census/socialexplorer/R11688823_SL140.csv")

density2010 <- 
  acs2010_t002 %>%
  select(GEOID = Geo_FIPS, 
         B01003_001 = SE_T002_001, 
         DENSITY = SE_T002_002, 
         ALAND = SE_T002_003) %>%
  mutate(year = "2006-2010")

density2015 <- 
  acs2015_t002 %>%
  select(GEOID = Geo_FIPS, 
         B01003_001 = SE_T002_001, 
         DENSITY = SE_T002_002, 
         ALAND = SE_T002_003) %>%
  mutate(year = "2011-2015")

# join with merged count data, 
# but replace estimate with DENSITY value and moe with NA

# merged_density_data.csv and treat like count data
# so use count data as template

merged_count_data <- 
  read_csv("data/census/merged_count_data.csv", 
           col_types = list(
             moe = col_double(), 
             tract = col_character()
           ))

data_template <- 
  merged_count_data %>%
  filter(variable == "B01003_001") %>%
  select(-variable, -estimate, -moe)

density_data <- bind_rows(density2010, density2015)

merged_density_data <- 
  data_template %>%
  left_join(density_data, by = c("GEOID", "year")) %>%
  select(-B01003_001) %>%
  gather(key = variable, value = estimate, DENSITY, ALAND) %>%
  mutate(moe = NA_real_) %>%
  select(one_of(names(merged_count_data)))

write_csv(merged_density_data, "data/census/merged_density_data.csv")

