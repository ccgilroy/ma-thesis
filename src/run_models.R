library(tidycensus)
library(purrr)
library(readr)
library(stringr)
library(dplyr)
library(tidyr)
library(tibble)
library(forcats)
library(ggplot2)

library(lme4)

# library(rstan)
# rstan_options(auto_write = TRUE)
# options(mc.cores = parallel::detectCores())

# setup ----
source("src/load_acs_variable_data.R")

d <-
  model_data_wide %>%
  filter(!(is.na(component) & gay == 1)) 
  
# filter(total_population_2010 > 0 & total_population_2015 > 0)

ggplot(d, aes(x = male_2010, y = male_2015)) + geom_point() + theme_minimal()

ggplot(d, aes(x = median_rent_2010, y = median_rent_2015)) + geom_point() + theme_minimal()

ggplot(d, aes(x = population_density_2010, y = population_density_2015)) + geom_point() + theme_minimal()

model1 <- lm(college_educated_2015 ~ college_educated_2010 + gay, data = d)

model2 <- lm(male_2015 ~ male_2010 + gay, data = d)

model3 <- lm(white_2015 ~ white_2010 + gay, data = d)

# TODO: really, I should keep the variables in the same column, so when I standardize, 
# it treats them together. Or, I should standardize first.
# Do I need to standardize the proportions, though?

f1 <- 
  college_educated_2015 ~ college_educated_2010 + male_2010 + married_2010 + 
  white_2010 + log(median_rent_2010) + log(median_income_2010) + 
  log(total_population_2010)
f2 <- update(f1, . ~ . + gay)

m1 <- lm(f1, data = d)
m2 <- lm(f2, data = d) # well, m2 is marginally better

ml_m1 <- lmer(update(f1, . ~ . + (1 | city)), data = d)
ml_m2 <- lmer(update(f2, . ~ . + (1 | city)), data = d)


ml_model1 <- lmer(college_educated_2015 ~ gay + college_educated_2010 + (1 | city), 
                  data = d)

ml_model3 <- lmer(white_2015 ~ gay + white_2010 + (1 | city), data = d)

college_educated_2015 ~ gay + college_educated_2010 + (1 | city)

# initial models ----
# (no matching)

run_models <- function(outcome, d) {
  f <- . ~ college_educated_2010 + male_2010 + married_2010 + 
    white_2010 + log(median_rent_2010) + log(median_income_2010) + 
    # log(total_population_2010)
    log(population_density_2010)
  
  f <- reduce(list(f, outcome), update)
  f_gay <- update(f, . ~ . + gay)
  f_ml <- update(f, . ~ . + (1 | city))
  f_ml_gay <- update(f_gay, . ~ . + (1 | city))
  
  # list(f, f_gay, f_ml, f_ml_gay)
  
  m <- lm(f, data = d)
  m_gay <- lm(f_gay, data = d)
  mlm <- lmer(f_ml, data = d)
  mlm_gay <- lmer(f_ml_gay, data = d)
  
  list(m = m, m_gay = m_gay, mlm = mlm, mlm_gay = mlm_gay)
}

m_col_edu <- run_models(college_educated_2015 ~ ., d)
m_white <- run_models(white_2015 ~ ., d)
m_male <- run_models(male_2015 ~ ., d)
m_married <- run_models(married_2015 ~ ., d)
m_rent <- run_models(log(median_rent_2015) ~ ., d) # weak / nonsig association with gay!
m_inc <- run_models(log(median_income_2015) ~ ., d)
m_dens <- run_models(log(population_density_2015) ~ ., d)

m_list <- list(
  m_col_edu = m_col_edu, 
  m_white = m_white, 
  m_male = m_male, 
  m_married = m_married, 
  m_rent = m_rent, 
  m_inc = m_inc, 
  m_dens = m_dens
)

map(m_col_edu, BIC)
map(m_white, BIC)
map(m_male, BIC)
map(m_married, BIC)
map(m_rent, BIC)
map(m_inc, BIC)

map_df(m_list, ~map_df(., BIC), .id = "outcome")

write_rds(m_list, path = "data/models/m_list.rds")

map(m_list, "m_gay") %>% map(summary)

map(m_list, "mlm_gay") %>% map(summary)

# in most cases, it's best to include both gay and random effects for cities

# rent actually turns out to be the weird one
# random effects ----
plot_ranef <- function(model, title = "") {
  ranef_df <- 
    data_frame(city = rownames(ranef(model)$city), 
               ranef = ranef(model)$city[,1], 
               se_ranef = arm::se.ranef(model)$city[,1])
  
  ranef_df %>%
    mutate(lower = ranef - 1.96*se_ranef, 
           upper = ranef + 1.96*se_ranef, 
           city = as.factor(city)) %>%
    ggplot(aes(x = fct_reorder(city, ranef), y = ranef)) +
    geom_pointrange(aes(ymin = lower, ymax = upper)) + 
    theme_minimal() + 
    geom_hline(yintercept = 0, color = "blue") +
    theme(axis.text.x = element_text(angle = 45)) +
    labs(x = "city", y = "intercept (centered at grand mean)", title = title) 
}

plot_ranef(m_list$m_col_edu$mlm_gay, "Outcome: proportion college educated")
plot_ranef(m_list$m_male$mlm_gay, "Outcome: proportion male")
# lol @Seattle and San Francisco...
plot_ranef(m_list$m_married$mlm_gay, "Outcome: proportion married")
# seems like high %-black cities are on the low end, 
# high %-Latino cities on the high end?

plot_ranef(m_list$m_white$mlm_gay, "Outcome: proportion white")
# what's up with Denver?

plot_ranef(m_list$m_rent$mlm_gay, "Outcome: log median rent")
# damn, that's a discontinuity right there
# this is one where the BIC indicated really obviously that it needed to be
# a multilevel model... so good?
plot_ranef(m_list$m_inc$mlm_gay, "Outcome: log median income")

plot_ranef(m_list$m_dens$mlm_gay, "Outcome: log population density")

# stan ----

library(rstanarm)
m2_b <- stan_glm(f2, data = d)
# multilevel model is too slow to run
# mlm <- stan_glmer(college_educated_2015 ~ college_educated_2010 + (1|city), data = d)
# ml_m2_b <- stan_lmer(update(f2, . ~ . + (1 | city)), data = d)

# matching ----
library(MatchIt)

# that's stupid, 
# it shouldn't matter if there are NA values in variables I'm not using for matching
d_test <- 
  d %>% 
  # filter(city %in% c("Boston")) %>%
  select(GEOID, city,
         gay, college_educated_2010, male_2010, married_2010, white_2010, 
         median_rent_2010, median_income_2010, total_population_2010, 
         population_density_2010) %>%
  as.data.frame() %>%
  magrittr::set_rownames(.$GEOID)

# d_test %>% 
#   select(gay, college_educated_2010, male_2010, married_2010, white_2010, median_rent_2010, median_income_2010, total_population_2010) %>%
#   mutate(log_income = log(median_income_2010), 
#          log_rent = log(median_rent_2010)) %>%
#   na.omit() %>% 
#   dim()

zz <- matchit(formula = gay ~ college_educated_2010 + male_2010 + married_2010 + 
                white_2010 + log10(median_rent_2010) + log10(median_income_2010) + 
                log10(total_population_2010), 
              data = as.data.frame(d_test), 
              # method = "optimal",
              method = "nearest",
              distance = "mahalanobis", 
              ratio = 1, 
              exact = c("city"))

zz2 <- matchit(formula = gay ~ college_educated_2010 + male_2010 + married_2010 + 
                 white_2010 + log10(median_rent_2010) + log10(median_income_2010) + 
                 log10(population_density_2010), 
               data = as.data.frame(d_test), 
               # method = "optimal",
               method = "nearest",
               distance = "mahalanobis", 
               ratio = 1, 
               exact = c("city"))



zz$match.matrix

# plot() and summary() are things

# sanity check
match.data(zz) %>%
  group_by(city) %>%
  summarize(gay = sum(gay), 
            n = n()) %>%
  mutate(prop = gay/n)

# seems way more consistent with nearest than optimal...
# it's also concerning that they're completely different
# HOW does mahalanobis distance value each covariate?
# I want them all standardized, basically...

library(leaflet)
# by tract
geometry_gay_tracts <- read_rds("data/census/geometry_2010_no_downtown.rds")

geometry_gay_tracts %>%
  # filter(GEOID %in% match.data(zz)$GEOID) %>%
  inner_join(match.data(zz2), by = "GEOID", suffix = c("", ".y")) %>%
  # mutate(gay = as.factor(gay)) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~as.character(GEOID), 
              opacity = 1, fillOpacity = .5, 
              color = ~colorFactor("Set2", gay)(gay))

# matching ----
d_matchit <- 
  d %>% 
  select(GEOID, city,
         gay, college_educated_2010, male_2010, married_2010, white_2010, 
         median_rent_2010, median_income_2010, total_population_2010, 
         population_density_2010) %>%
  as.data.frame() %>%
  magrittr::set_rownames(.$GEOID)

match_results <- 
  matchit(formula = gay ~ college_educated_2010 + male_2010 + married_2010 + 
            white_2010 + log10(median_rent_2010) + log10(median_income_2010) + 
            log10(population_density_2010), 
          data = d_matchit, 
          method = "nearest",
          distance = "mahalanobis", 
          ratio = 1, 
          exact = c("city"))

geometry_gay_tracts %>%
  inner_join(match.data(match_results), by = "GEOID", suffix = c("", ".y")) %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(label = ~as.character(GEOID), 
              opacity = 1, fillOpacity = .5, 
              color = ~colorFactor("Set2", gay)(gay))

matched_tracts <- match.data(match_results)$GEOID

d_matched <- 
  d %>%
  filter(GEOID %in% matched_tracts)

# test models ----
m_col_edu_matched <- run_models(college_educated_2015 ~ ., d_matched)
m_white_matched <- run_models(white_2015 ~ ., d_matched)
m_male_matched <- run_models(male_2015 ~ ., d_matched)
m_married_matched <- run_models(married_2015 ~ ., d_matched)
m_rent_matched <- run_models(log(median_rent_2015) ~ ., d_matched) # weak / nonsig association with gay!
m_inc_matched <- run_models(log(median_income_2015) ~ ., d_matched)
m_dens_matched <- run_models(log(population_density_2015) ~ ., d_matched)

m_list_matched <- list(
  m_col_edu_matched = m_col_edu_matched, 
  m_white_matched = m_white_matched, 
  m_male_matched = m_male_matched, 
  m_married_matched = m_married_matched, 
  m_rent_matched = m_rent_matched, 
  m_inc_matched = m_inc_matched, 
  m_dens_matched = m_dens_matched
)

map(m_list_matched, "m_gay") %>% map(summary)

map(m_list_matched, "mlm_gay") %>% map(summary)

map(m_list_matched, "m_gay")$m_inc_matched %>% summary()
map(m_list, "m_gay")$m_inc %>% summary()

map(m_list_matched, "m_gay")$m_col_edu_matched %>% summary()
map(m_list, "m_gay")$m_col_edu %>% summary()

# model on tract-aggregate level ----

d_matchinfo <- 
  data_frame(
    gay_tract = rownames(match_results$match.matrix),
    matched_tract = match_results$match.matrix[, 1]
  ) %>%
  left_join(select(d_matched, GEOID, matched_component = component), 
            by = c("gay_tract" = "GEOID"))

d_matchinfo1 <-
  d_matchinfo %>%
  rename(GEOID = gay_tract)

d_matchinfo2 <-
  d_matchinfo %>%
  select(GEOID = matched_tract, matched_tract = gay_tract, matched_component)

d_matchinfo <- bind_rows(d_matchinfo1, d_matchinfo2)

d_aggregated <- 
  d_matched %>%
  left_join(d_matchinfo, by = "GEOID") %>%
  mutate(component = ifelse(is.na(component), matched_component, component)) %>%
  group_by(city, gay, component, neighborhood_label) %>%
  summarise(
    # 2010 variables
    college_educated_2010 = sum(college_educated_2010 * total_population_2010) / sum(total_population_2010), 
    male_2010 = sum(male_2010 * total_population_2010) / sum(total_population_2010), 
    married_2010 = sum(married_2010 * total_population_2010) / sum(total_population_2010), 
    white_2010 = sum(white_2010 * total_population_2010) / sum(total_population_2010), 
    
    median_income_2010 = sum(median_income_2010 * total_population_2010) / sum(total_population_2010), 
    median_rent_2010 = sum(median_rent_2010 * total_population_2010) / sum(total_population_2010), 
    
    population_density_2010 = sum(total_population_2010) / sum(total_population_2010/population_density_2010),
    total_population_2010 = sum(total_population_2010),
    
    # 2015 variables
    college_educated_2015 = sum(college_educated_2015 * total_population_2015) / sum(total_population_2015), 
    male_2015 = sum(male_2015 * total_population_2015) / sum(total_population_2015), 
    married_2015 = sum(married_2015 * total_population_2015) / sum(total_population_2015), 
    white_2015 = sum(white_2015 * total_population_2015) / sum(total_population_2015), 
    
    median_income_2015 = sum(median_income_2015 * total_population_2015) / sum(total_population_2015), 
    median_rent_2015 = sum(median_rent_2015 * total_population_2015) / sum(total_population_2015), 
    
    population_density_2015 = sum(total_population_2015) / sum(total_population_2015/population_density_2015),
    total_population_2015 = sum(total_population_2015)
  )

m_col_edu_aggregated <- run_models(college_educated_2015 ~ ., d_aggregated)
m_white_aggregated <- run_models(white_2015 ~ ., d_aggregated)
m_male_aggregated <- run_models(male_2015 ~ ., d_aggregated)
m_married_aggregated <- run_models(married_2015 ~ ., d_aggregated)
m_rent_aggregated <- run_models(log(median_rent_2015) ~ ., d_aggregated) # weak / nonsig association with gay!
m_inc_aggregated <- run_models(log(median_income_2015) ~ ., d_aggregated)
m_dens_aggregated <- run_models(log(population_density_2015) ~ ., d_aggregated)

m_list_aggregated <- list(
  m_col_edu_aggregated = m_col_edu_aggregated, 
  m_white_aggregated = m_white_aggregated, 
  m_male_aggregated = m_male_aggregated, 
  m_married_aggregated = m_married_aggregated, 
  m_rent_aggregated = m_rent_aggregated, 
  m_inc_aggregated = m_inc_aggregated, 
  m_dens_aggregated = m_dens_aggregated
)

map_df(m_list_aggregated, ~map_df(., BIC), .id = "outcome")

map(m_list_aggregated, "m_gay") %>% map(summary)

# try stan again? ----
# options(mc.cores = parallel::detectCores())
f <- college_educated_2015 ~ college_educated_2010 + male_2010 + married_2010 + 
  white_2010 + log(median_rent_2010) + log(median_income_2010) + 
  # log(total_population_2010)
  log(population_density_2010) + 
  gay

stan_test <- stan_glm(f, data = d_aggregated)

# plot coefficients ----
library(broom)

tidy(m_list_aggregated$m_col_edu_aggregated$m_gay)

process_model <- function(m) {
  tidy(m) %>%
    mutate(outcome = str_c(as.character(terms(m)[[2]]), collapse = " ")) %>%
    mutate(data = case_when(
      df.residual(m) <= nrow(d_aggregated) ~ "aggregated", 
      df.residual(m) <= nrow(d_matched)  ~ "matched", 
      signif(df.residual(m), digits = 2) == signif(nrow(d), digits = 2) ~ "all", 
      TRUE ~ NA_character_
    )) %>% 
    mutate(multilevel = ("lmerMod" %in% class(m)))
}

tidy_aggregated <- map_df(m_list_aggregated, ~map_df(., process_model))
tidy_matched <- map_df(m_list_matched, ~map_df(., process_model))
tidy_all <- map_df(m_list, ~map_df(., process_model))

tidied_coefficients <- as_tibble(bind_rows(tidy_aggregated, tidy_matched, tidy_all))

tidied_coefficients %>%
  filter(term == "gay") %>%
  mutate(data = as_factor(data), 
         data = fct_relevel(data, "all", "matched", "aggregated")) %>%
  ggplot(aes(x = outcome, y = estimate, color = data)) + 
  geom_pointrange(aes(ymin = estimate - 1.96 * std.error, 
                      ymax = estimate + 1.96 * std.error), 
                  position = position_dodge(width = .7)) +
  coord_flip() +
  facet_wrap(~multilevel) +
  theme_minimal() + 
  geom_hline(yintercept = 0) + 
  ggthemes::scale_color_solarized()

tidied_coefficients %>%
  filter(term == "gay") %>%
  mutate(data = ifelse(data == "all" & multilevel, "all (multilevel)", data)) %>%
  filter(!multilevel | data == "all (multilevel)") %>%
  mutate(data = as_factor(data), 
         data = fct_relevel(data, "all", "all (multilevel)", "matched", "aggregated")) %>%
  mutate(outcome = fct_relevel(outcome, 
                               "college_educated_2015", 
                               "male_2015", 
                               "married_2015", 
                               "white_2015", 
                               "log median_income_2015",
                               "log median_rent_2015", 
                               "log population_density_2015")) %>%
  mutate(outcome = fct_recode(
    outcome, 
    `proportion college-educated, 2015` = "college_educated_2015", 
    `proportion male, 2015` = "male_2015", 
    `proportion married, 2015` = "married_2015", 
    `proportion white, 2015` = "white_2015", 
    `median income, 2015 ($, logged)` = "log median_income_2015",
    `median rent, 2015 ($, logged)` = "log median_rent_2015", 
    `population density (per sq. mi., logged)` = "log population_density_2015"
  )) %>%
  ggplot(aes(x = estimate, y = fct_rev(outcome), color = fct_rev(data))) + 
  ggstance::geom_pointrangeh(aes(xmin = estimate - 1.96 * std.error, 
                                 xmax = estimate + 1.96 * std.error), 
                             position = ggstance::position_dodgev(height = .6)) +
  # coord_flip() +
  theme_minimal() + 
  geom_vline(xintercept = 0, linetype = "dashed") + 
  # ggthemes::scale_color_solarized() + 
  scale_color_brewer(type = "qual", palette = "Set1") +
  guides(color = guide_legend(reverse = TRUE)) + 
  labs(title = "Coefficient plot of indicator for gay neighborhoods", 
       x = "estimated coefficient and 95% CI", 
       y = "outcome", 
       color = "tracts") 

library(texreg)
texreg(m_list_aggregated$m_col_edu_aggregated$m_gay)

# stargazer::stargazer(c(m_list$m_col_edu$m_gay, m_list$m_col_edu$mlm_gay))

texreg(list(m_list$m_col_edu$m_gay, 
            m_list$m_col_edu$mlm_gay, 
            m_list_matched$m_col_edu_matched$m_gay, 
            m_list_aggregated$m_col_edu_aggregated$m_gay
       ), 
       include.aic = TRUE, 
       include.bic = TRUE, 
       digits = 3, 
       booktabs = TRUE)

stargazer::stargazer(m_list$m_col_edu$m_gay, keep.stat = c("aic", "n"))

# buffer ----
library(sf)
geometry_b01003_2010_bc_nd <- 
  read_rds("data/census/geometry_2010_no_downtown.rds")
