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
library(ggplot2)

# setup ----
source("src/load_acs_variable_data.R")

# summarise from tracts to components ----
# TODO: decide if I want to use weighted averages by total population
qual_summarised <- 
  main_data_gay_qual %>%
  group_by(component, csize, neighborhood_label, 
           state, city, year, variable, label) %>%
  summarise(estimate_mean = mean(estimate), 
            estimate_sd = sd(estimate),
            estimate = sum(estimate), 
            moe = moe_sum(moe),
            summary_est = sum(summary_est), 
            summary_moe = moe_sum(moe),
            bars = sum(bars)) %>%
  mutate(prop = estimate/summary_est, 
         prop_moe = moe_prop(estimate, summary_est, moe, summary_moe)) 

# counts = sum
# summary = sum
# medians = average
# props = recalc prop

# works for everything except averages

# TODO: use conversion factor for income!
conversion_factor <- 1.08710584
usd_vars <- c("median income", "median rent")

qual_summarised <- 
  qual_summarised %>%
  mutate(estimate = ifelse(label %in% usd_vars, estimate_mean, estimate), 
         estimate = ifelse(label %in% usd_vars & year == "2006-2010", 
                           estimate*conversion_factor, estimate)) 

qual_prop <- 
  qual_summarised %>%
  mutate(estimate = ifelse(is.na(prop), estimate, prop), 
         moe = ifelse(is.na(prop), moe, prop_moe)) %>%
  select(-c(summary_est, summary_moe, prop, prop_moe))

# yikes, not a whole lot of change here, on average.
# but maybe that's my point?
qual_prop %>%
  group_by(label, year) %>%
  summarise(mean = mean(estimate, na.rm = TRUE), sd = sd(estimate, na.rm = TRUE)) %>%
  select(-sd) %>% 
  ungroup() %>%
  spread(year, mean) 

qual_prop %>%
  select(component, csize, neighborhood_label, state, city, label, variable, year, estimate) %>%
  spread(year, estimate) %>%
  mutate(difference = `2011-2015` - `2006-2010`) %>% 
  group_by(label) %>%
  summarise(mean_diff = round(mean(difference, na.rm = TRUE), 4), 
            sd_diff = round(sd(difference, na.rm = TRUE), 4), 
            min_diff = round(min(difference, na.rm = TRUE), 4), 
            max_diff = round(max(difference, na.rm = TRUE), 4))

qual_prop %>%
  select(component, csize, neighborhood_label, state, city, label, variable, year, estimate) %>%
  spread(year, estimate) %>%
  mutate(difference = `2011-2015` - `2006-2010`) %>%
  ggplot(aes(x = difference)) +
  geom_density() +
  facet_wrap(~label, scales = "free")

qual_prop %>%
  ggplot(aes(x = estimate, color = year)) +
  geom_density() +
  facet_wrap(~label, scales = "free") +
  theme_minimal()

# lines, but with just one variable

# wide data frames ----

qual_count_wide <-
  qual_summarised %>%
  ungroup() %>%
  select(label, estimate, year, component, csize, neighborhood_label, 
         state, city) %>%
  spread(key = label, value = estimate)

qual_prop_wide <- 
  qual_prop %>%
  ungroup() %>%
  select(label, estimate, year, component, csize, neighborhood_label, 
         state, city, bars) %>%
  spread(key = label, value = estimate)

# plots ----

# single variable plots ----
qual_prop_wide %>%
  ggplot(aes(x = year, y = male, group = component)) + 
  geom_path() +
  ggtitle("Changes in proportion male") +
  theme_minimal() +
  geom_text(aes(label = str_c(city, component, sep = " ")), 
            data = filter(qual_prop_wide, year == "2006-2010"), 
            nudge_x = -.15, size = 2.5) + 
  geom_text(aes(label = str_c(neighborhood_label, city, sep = ", ")), 
            data = filter(qual_prop_wide, year == "2011-2015"), 
            nudge_x = .3, size = 2.5)

qual_prop_wide %>%
  ggplot(aes(x = year, y = white, group = component)) + 
  geom_path() +
  ggtitle("Changes in proportion white") +
  theme_minimal() +
  geom_text(aes(label = str_c(city, component, sep = " ")), 
            data = filter(qual_prop_wide, year == "2006-2010"), 
            nudge_x = -.15, size = 2.5) + 
  geom_text(aes(label = str_c(neighborhood_label, city, sep = ", ")), 
            data = filter(qual_prop_wide, year == "2011-2015"), 
            nudge_x = .3, size = 2.5)

plot_married_1way <- 
  qual_prop_wide %>%
  ggplot(aes(x = year, y = married, group = component)) + 
  geom_path() +
  ggtitle("Change in proportion married") +
  theme_minimal() +
  geom_text(aes(label = str_c(neighborhood_label, city, sep = ", ")), 
            data = filter(qual_prop_wide, year == "2006-2010"), 
            nudge_x = -.05, size = 2.5, hjust = "outward") + 
  geom_text(aes(label = str_c(neighborhood_label, city, sep = ", ")), 
            data = filter(qual_prop_wide, year == "2011-2015"), 
            nudge_x = .05, size = 2.5, hjust = "outward") + 
  labs(x = NULL)

ggsave("output/figures/married_1way.png", plot_married_1way, 
       width = 6, 
       height = 12)

plot_education_1way <- 
  qual_prop_wide %>%
  ggplot(aes(x = year, y = `college educated`, group = component)) + 
  geom_path() +
  ggtitle("Change in proportion college-educated or higher") +
  theme_minimal() +
  geom_text(aes(label = str_c(neighborhood_label, city, sep = ", ")), 
            data = filter(qual_prop_wide, year == "2006-2010"), 
            nudge_x = -.05, size = 2.5, hjust = "outward") + 
  geom_text(aes(label = str_c(neighborhood_label, city, sep = ", ")), 
            data = filter(qual_prop_wide, year == "2011-2015"), 
            nudge_x = .05, size = 2.5, hjust = "outward") + 
  labs(x = NULL)

ggsave("output/figures/education_1way.png", plot_education_1way, 
       width = 6, 
       height = 12)

qual_prop_wide %>%
  ggplot(aes(x = year, y = `median income`, group = component)) + 
  geom_path() +
  ggtitle("Changes in median income") +
  theme_minimal() +
  geom_text(aes(label = str_c(city, component, sep = " ")), 
            data = filter(qual_prop_wide, year == "2006-2010"), 
            nudge_x = -.15, size = 2.5) + 
  geom_text(aes(label = str_c(city, component, sep = " ")), 
            data = filter(qual_prop_wide, year == "2011-2015"), 
            nudge_x = .15, size = 2.5)

qual_prop_wide %>%
  ggplot(aes(x = year, y = `median rent`, group = component)) + 
  geom_path() +
  ggtitle("Changes in median rent") +
  theme_minimal() +
  geom_text(aes(label = str_c(city, component, sep = " ")), 
            data = filter(qual_prop_wide, year == "2006-2010"), 
            nudge_x = -.15, size = 2.5) + 
  geom_text(aes(label = str_c(city, component, sep = " ")), 
            data = filter(qual_prop_wide, year == "2011-2015"), 
            nudge_x = .15, size = 2.5)

# two-way plots ----
ggplot(aes(x = white, y = male, group = component)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.125, "inches"), type = "closed")) +
  ggtitle("White (X) vs Male (Y)")

qual_prop_wide %>%
  ggplot(aes(x = white, y = male, group = component)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  ggtitle("Changes in proportion white and proportion male") +
  theme_minimal() +
  geom_text(aes(x = white, y = male, label = city), 
            data = filter(qual_prop_wide, year == "2006-2010"))


qual_count_wide %>%
  ggplot(aes(x = white, y = male, group = component)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  ggtitle("Changes in count white and count male") +
  theme_minimal() +
  geom_text(aes(x = white, y = male, label = city), 
            data = filter(qual_count_wide, year == "2006-2010"))

plot_white_married_2way <- 
  qual_prop_wide %>%
  mutate(label_bool = ifelse(city %in% c("Chicago", "Seattle"), 
                             "labelled", "not labelled")) %>%
  ggplot(aes(x = white, y = married, group = component, color = label_bool)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  labs(title = "Changes in proportion white and proportion married in gay neighborhoods", 
       subtitle = "Comparing neighborhood-level values for each characteristic",
       caption = "Arrows connect a neighborhood in 2006-2010\nto the same neighborhood in 2011-2015", 
       x = "proportion white (individuals)", 
       y = "proportion in different-sex marriage (households)") + 
  theme_minimal() +
  scale_color_manual(values = c("#BD0026", "black"), guide = FALSE) +
  geom_label(aes(x = white, y = married, 
                 label = str_c(neighborhood_label, city, sep = ", ")),
             color = "#BD0026",
             data = filter(qual_prop_wide, year == "2011-2015", 
                           city %in% c("Chicago", "Seattle")), 
             hjust = 0.25, vjust = 0, 
             nudge_x = .001, nudge_y = .001)

plot_male_married_2way <-
  qual_prop_wide %>%
  mutate(label_bool = ifelse(city %in% c("Chicago", "Seattle"), 
                             "labelled", "not labelled")) %>%
  ggplot(aes(x = male, y = married, group = component, color = label_bool)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  labs(title = "Changes in proportion male and proportion married in gay neighborhoods", 
       subtitle = "Comparing neighborhood-level values for each characteristic",
       caption = "Arrows connect a neighborhood in 2006-2010\nto the same neighborhood in 2011-2015", 
       x = "proportion male (individuals)", 
       y = "proportion in different-sex marriage (households)") + 
  theme_minimal() +
  scale_color_manual(values = c("#BD0026", "black"), guide = FALSE) +
  geom_label(aes(x = male, y = married, 
                 label = str_c(neighborhood_label, city, sep = ", ")),
             color = "#BD0026",
             data = filter(qual_prop_wide, year == "2011-2015", 
                           city %in% c("Chicago", "Seattle")), 
             hjust = 0.25, vjust = 0, 
             nudge_x = .001, nudge_y = .001)

ggsave("output/figures/white_married_2way.png", plot_white_married_2way,
       width = 8, height = 5)

qual_count_wide %>%
  ggplot(aes(x = `median income`, y = `median rent`, group = component)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  ggtitle("Changes in median income and median rent") +
  theme_minimal() +
  geom_text(aes(x = `median income`, y = `median rent`, label = str_c(city, component)), 
            data = filter(qual_count_wide, year == "2006-2010"))

qual_prop_wide %>%
  ggplot(aes(x = white, y = `median income`, group = component)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  ggtitle("Changes in proportion white and median income") +
  theme_minimal() +
  geom_text(aes(x = white, y = `median income`, label = str_c(city, component)), 
            data = filter(qual_prop_wide, year == "2006-2010"))

qual_prop_wide %>%
  ggplot(aes(x = `median income`, y = `college educated`, group = component)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  ggtitle("Changes in median income and proportion college educated") +
  theme_minimal() +
  geom_text(aes(label = str_c(city, component)), 
            data = filter(qual_prop_wide, year == "2006-2010"))

plot_rent_education_2way <- 
  qual_prop_wide %>%
  ggplot(aes(x = `median rent`, y = `college educated`, group = component)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  labs(title = "Changes in median rent and proportion college educated in gay neighborhoods", 
       subtitle = "Comparing neighborhood-level values for each characteristic",
       caption = "Arrows connect a neighborhood in 2006-2010\nto the same neighborhood in 2011-2015", 
       x = "median rent, 2015 dollars", 
       y = "proportion college-educated") +
  theme_minimal() # +
  # geom_text(aes(label = str_c(city, component)),
  #           data = filter(qual_prop_wide, year == "2006-2010"))

ggsave("output/figures/rent_education_2way.png", plot_rent_education_2way,
       width = 8, height = 5)

options(scipen = 99)
plot_inc_education_2way <- 
  qual_prop_wide %>%
  mutate(label_bool = ifelse(city %in% c("Chicago", "Seattle"), 
                             "labelled", "not labelled")) %>%
  ggplot(aes(x = `median income`, y = `college educated`, group = component, color = label_bool)) + 
  geom_path(arrow = arrow(angle = 15, ends = "last", length = unit(.05, "inches"), type = "closed")) +
  labs(title = "Changes in median income and proportion college educated in gay neighborhoods", 
       subtitle = "Comparing neighborhood-level values for each characteristic",
       caption = "Arrows connect a neighborhood in 2006-2010\nto the same neighborhood in 2011-2015", 
       x = "median income, 2015 dollars", 
       y = "proportion college-educated") +
  scale_color_manual(values = c("#BD0026", "black"), guide = FALSE) +
  theme_minimal() + 
  geom_label(aes(x = `median income`, y = `college educated`, 
                 label = str_c(neighborhood_label, city, sep = ", ")),
             color = "#BD0026",
             data = filter(qual_prop_wide, year == "2011-2015", 
                           city %in% c("Chicago", "Seattle")), 
             hjust = 0.25, vjust = 0, 
             nudge_x = 10, nudge_y = .005)

ggsave("output/figures/inc_education_2way.png", plot_inc_education_2way,
       width = 8, height = 5)


# qual_prop_wide %>%
#   filter(year == "2006-2010") %>%
#   select()
  
# maps ----
library(leaflet)
# by tract
geometry_gay_tracts <- read_rds("data/census/geometry_2010_no_downtown.rds")

qual_tracts_for_map <- 
  geometry_gay_tracts %>%
  select(GEOID, geometry) %>%
  inner_join(main_data_gay_qual, by = "GEOID")

map_diff <- 
  qual_tracts_for_map %>%
  filter(label == "college educated") %>%
  select(-c(estimate, moe, summary_est, summary_moe, prop_moe)) %>%
  spread(key = year, value = prop) %>%
  mutate(difference = `2011-2015` - `2006-2010`) 
map_diff %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~as.character(GEOID), 
              opacity = 1, fillOpacity = .5, 
              color = ~colorNumeric("RdBu", difference)(difference), 
              popup = ~as.character(str_c("% change in college educated: ", round(difference, 3)))) %>%
  addLegend(pal = colorNumeric("RdBu", map_diff$difference), values = ~difference)

map_diff <- 
  qual_tracts_for_map %>%
  filter(label == "median rent") %>%
  select(-c(prop, moe, summary_est, summary_moe, prop_moe)) %>%
  spread(key = year, value = estimate) %>%
  mutate(difference = `2011-2015` - `2006-2010`) 
map_diff %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~as.character(GEOID), 
              opacity = 1, fillOpacity = .5, 
              color = ~colorNumeric("RdBu", difference)(difference), 
              popup = ~as.character(str_c("change in median rent: ", round(difference, 3)))) %>%
  addLegend(pal = colorNumeric("RdBu", map_diff$difference), values = ~difference)

# by component
geometry_gay_components <- 
  read_rds()

# clustering and correlation ----
# am I just looking for a correlation matrix of the changes? a pca?
qual_prop_diff_wide <- 
  qual_prop %>%
  ungroup() %>%
  select(component, csize, state, city, label, year, estimate) %>%
  spread(year, estimate) %>%
  mutate(difference = `2011-2015` - `2006-2010`) %>%
  select(-c(`2011-2015`, `2006-2010`)) %>%
  spread(key = label, value = difference) %>%
  rename(median_income = `median income`, 
         median_rent = `median rent`, 
         total_population = `total population`, 
         college_educated = `college educated`)

qual_prop_diff_wide %>%
  select(-c(component, csize, state, city)) %>%
  cor()

qual_prop_diff_wide_scaled <- 
  qual_prop_diff_wide %>%
  mutate_at(vars(college_educated, male, married, median_income, median_rent, total_population, white), scale)

# otoh, maybe some things changed more than others...
# scaling weights changes on each dimension the same
pca <- 
  princomp(~ college_educated + male + married + median_income + median_rent + total_population + white,
           data = qual_prop_diff_wide_scaled)

qual_prop_diff_wide %>%
  bind_cols(as_data_frame(pca$scores)) %>%
  ggplot(aes(x = Comp.1, y = Comp.2)) + 
  geom_point() +
  theme_minimal() + 
  geom_text(aes(x = Comp.1, y = Comp.2, label = str_c(city, component)))

# largest proportion of variance, by far, is in income and population change
# what does that mean, tho?

# t-sne or something to cluster observations by the kinds of changes
# they experienced?

summary(pca)
loadings(pca)
# make wide
# two versions - one with props as props
# one with props as counts

# then plot 

# make a table ----
table_data <- 
  main_data %>%
  left_join(geometry_components_qual_filtered, by = "GEOID") %>%
  mutate(tract_type = case_when(
    gay == 0 ~ "Tracts without gay bars",
    gay == 1 & is.na(component) ~ "Other tracts with gay bars",
    gay == 1 & !is.na(component) ~ "Tracts in gay neighborhoods"
  )) %>%
  mutate(estimate = ifelse(label %in% usd_vars & year == "2006-2010", 
                           estimate*conversion_factor, estimate)) %>%
  mutate(estimate = ifelse(is.na(prop), estimate, prop), 
         moe = ifelse(is.na(prop), moe, prop_moe)) %>%
  select(-c(summary_est, summary_moe, prop, prop_moe))

library(forcats)
table_data_wide <- 
  table_data %>%
  filter(label != "total population") %>%
  group_by(year, label, tract_type) %>%
  summarise(estimate = mean(estimate, na.rm = TRUE)) %>%
  ungroup() %>%
  spread(key = year, value = estimate) %>%
  mutate(label = as.factor(label), 
         label = fct_relevel(label, "white", after = 3)) %>%
  arrange(label)

gay_tracts <- 
  table_data_wide %>% 
  filter(tract_type == "Tracts in gay neighborhoods") %>%
  select(-tract_type) %>%
  column_to_rownames("label") %>%
  as.matrix()

other_gay_tracts <- 
  table_data_wide %>% 
  filter(tract_type == "Other tracts with gay bars") %>%
  select(-tract_type) %>%
  column_to_rownames("label") %>%
  as.matrix()

other_tracts <- 
  table_data_wide %>% 
  filter(tract_type == "Tracts without gay bars") %>%
  select(-tract_type) %>%
  column_to_rownames("label") %>%
  as.matrix()

mx <- cbind(gay_tracts, other_gay_tracts, other_tracts)

library(knitr)
library(kableExtra)
kable(mx, 
      format = "latex", 
      booktabs = TRUE, 
      caption = "Average values for tracts", 
      align = "r", 
      digits = 2) %>%
  add_header_above(c(" ", 
                     "N = 146" = 2, 
                     "N = 342" = 2, 
                     "N = 22519" = 2),
                   italic = TRUE) %>%
  add_header_above(c(" ", 
                     "Gay neighborhood tracts" = 2, 
                     "Other tracts with gay bars" = 2, 
                     "Tracts without gay bars" = 2)) %>%
  write_lines("output/tables/averages.md")

qual_filtered_components_labeled %>%
  as.data.frame() %>% 
  select(-geometry) %>% 
  as_tibble() %>% 
  select(city, neighborhood_label, csize, bars) %>% 
  mutate(city = as.factor(city)) %>% 
  mutate(city = fct_relevel(city, 
                            "New York", 
                            "San Francisco", 
                            "Chicago", 
                            "Los Angeles")) %>%
  arrange(city, desc(bars)) %>% 
  # mutate(`sample references` = "") %>%
  rename(City = city, 
         Neighborhood = neighborhood_label, 
         Tracts = csize, 
         Bars = bars) %>%
  knitr::kable()
