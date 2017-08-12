library(httr)
library(stringr)
library(tidyverse)
library(yaml)

keys <- yaml.load_file("src/census.yml")
census_key <- keys$census_key

acs5_2015 <- "http://api.census.gov/data/2015/acs5"
query_list <- list(
  get = "B01003_001E,B01003_001M,NAME",
  `for` = "place:*",
  key = census_key
)

places_pop <- GET(acs5_2015, query = query_list)

places_pop_df <- 
  content(places_pop) %>%
  # unnest the list of lists one level
  map(unlist) %>%
  # the first row is column names
  {map(.[-1], set_names, nm = .[[1]])} %>%
  map_df(bind_rows)

places_pop_df <-
  places_pop_df %>%
  mutate(B01003_001E = as.numeric(B01003_001E), 
         B01003_001M = as.numeric(B01003_001M)) %>%
  arrange(desc(B01003_001E))

if (!dir.exists(file.path("data", "census"))) {
  dir.create(file.path("data", "census"))
}

write_csv(places_pop_df, file.path("data", "census", "places_by_pop.csv"))

top100 <- 
  places_pop_df %>%
  head(100) %>%
  .$NAME %>%
  str_replace(" city,", ",") %>%
  str_replace(" CDP,", ",") %>%
  str_replace(" municipality,", ",") %>%
  str_replace(" zona urbana,", ",") %>%
  str_replace(" town,", ",") %>%
  str_replace("-Fayette urban county,", ",") %>%
  str_replace("-Davidson metropolitan government \\(balance\\),", ",") %>%
  str_replace("/Jefferson County metro government \\(balance\\),", ",") %>%
  str_replace(" city \\(balance\\),", ",") %>%
  str_replace("^Urban ", "")

top50 <- top100[1:50]

write_lines(top100, file.path("data", "census", "top100cities.txt"))
