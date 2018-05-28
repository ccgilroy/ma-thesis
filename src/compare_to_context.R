library(tidycensus)
library(purrr)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)
library(tibble)
library(forcats)
library(yaml)

library(ggplot2)

source("src/load_acs_variable_data.R")

# goal: get into wide form like with plot_descriptives
# then summarise and look at the descriptives
# join by city to gay data (or main data) for contextual / city level info

# summarize by city ----
# (a couple cities span multiple counties)
city_summarised <- 
  main_data %>%
  # get rid of Will County IL temporarily until I decide on MSA vs county
  # this is different from the Atlanta case, where Atlanta actually spans 
  # two counties...
  filter(!(state == "17" & county == "197")) %>%
  # filter(!is.na(estimate)) %>%
  # TODO: drop `state` here because of St Louis?
  # and just join on city
  group_by(state, city, year, variable, label) %>%
  summarise(estimate_mean = mean(estimate, na.rm = TRUE), 
            estimate_sd = sd(estimate, na.rm = TRUE),
            estimate = sum(estimate, na.rm = TRUE), 
            moe = moe_sum(moe),
            summary_est = sum(summary_est), 
            summary_moe = moe_sum(moe),
            bars = sum(bars)) %>%
  mutate(prop = estimate/summary_est, 
         prop_moe = moe_prop(estimate, summary_est, moe, summary_moe)) 

conversion_factor <- 1.08710584
usd_vars <- c("median income", "median rent")

city_summarised <- 
  city_summarised %>%
  mutate(estimate = ifelse(label %in% usd_vars, estimate_mean, estimate), 
         estimate = ifelse(label %in% usd_vars & year == "2006-2010", 
                           estimate*conversion_factor, estimate)) 

city_prop <- 
  city_summarised %>%
  mutate(estimate = ifelse(is.na(prop), estimate, prop), 
         moe = ifelse(is.na(prop), moe, prop_moe)) %>%
  select(-c(summary_est, summary_moe, prop, prop_moe))

city_prop_wide <- 
  city_prop %>%
  ungroup() %>%
  select(label, estimate, year, 
         state, city, bars) %>%
  spread(key = label, value = estimate)

city_prop_diff <- 
  city_prop %>%
  ungroup() %>%
  select(label, estimate, year, 
         state, city, bars) %>%
  group_by(state, city, bars, label) %>%
  arrange(year) %>%
  summarise(difference = last(estimate) - first(estimate))

city_prop_diff %>% 
  filter(!label %in% c("total population", "median income", "median rent")) %>% 
  knitr::kable(digits = 3)


# there are some weird NAs to work out in these summaries!
# maybe to do with filtering NAs above...

# can't really trust median income and median rent data, 
# should request

# TODO: import this elegantly from plot_descriptives!
city_prop_to_join <- 
  city_prop %>%
  ungroup() %>%
  select(state, city, year, variable, label, estimate, bars) 
  
# TODO: fix my median variables! They're wrong!
compare_prop <- 
  qual_prop %>%
  ungroup() %>%
  select(-estimate_mean, -estimate_sd) %>%
  left_join(city_prop_to_join, 
            by = c("state", "city", "year", "variable", "label"), 
            suffix = c("", "_city"))

compare_prop %>%
  filter(!label %in% c("total population", "median income", "median rent", "population density")) %>% 
  ggplot(aes(x = estimate, y = estimate_city, color = year,
             group = component)) + 
  geom_point() + 
  geom_path(color = "black", arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  facet_wrap(~label) + 
  theme_minimal() +
  geom_abline(slope = 1, intercept = 0) +
  labs(title = "Demographics of Gay Neighborhoods", 
       subtitle = "Relative to the counties in which their cities are located")

plot_demographic_comparison <- 
  compare_prop %>%
  filter(!label %in% c("total population", "median income", "median rent", "population density")) %>% 
  ggplot(aes(x = estimate, y = estimate_city, # color = year,
             group = component)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  facet_wrap(~label) + 
  theme_minimal() +
  geom_abline(slope = 1, intercept = 0, color = "#BD0026") +
  labs(title = "Demographics of Gay Neighborhoods", 
       subtitle = "Relative to the counties in which their cities are located", 
       x = "proportion in gay neighborhood", 
       y = "proportion in county", 
       caption = "Arrows connect a neighborhood in 2006-2010\nto the same neighborhood in 2011-2015")

ggsave("output/figures/demographic_comparison.png", plot_demographic_comparison, 
       height = 5, width = 8)

compare_prop %>%
  filter(label == "male") %>%
  ggplot(aes(x = estimate, y = estimate_city, # color = year,
             group = component)) + 
  # geom_point() + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.125, "inches"), type = "closed")) +
  # geom_path(color = "black") +
  theme_minimal() +
  geom_abline(slope = 1, intercept = 0, color = "#BD0026")

# for a lark, let's compare to all "gay" tracts

compare_all_tracts <- 
  main_data_gay %>%
  filter(!label %in% c("total population", "median income", "median rent")) %>% 
  left_join(city_prop_to_join, 
            by = c("state", "city", "year", "variable", "label"), 
            suffix = c("", "_city"))

compare_all_tracts %>%
  sample_frac(.1) %>%
  ggplot(aes(x = prop, y = estimate_city,  color = year)) + 
  geom_point() +
  # geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  facet_wrap(~label) + 
  theme_minimal() +
  geom_abline(slope = 1, intercept = 0, color = "#BD0026")
# this is pretty good evidence that I'm rigth to exclude all tracts
  
# there are 23207 tracts
# of the 323292 observations, 1779 are NAs...
# not bad, but why?
# the NAs are rent and income
# I guess these are tracts where no one had an income or rent? 
# at least in the sample
main_data %>%
  filter(is.na(estimate)) %>%
  .$label %>% as.factor() %>% summary()

