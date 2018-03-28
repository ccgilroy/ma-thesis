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

run_models <- function(outcome) {
  f <- . ~ college_educated_2010 + male_2010 + married_2010 + 
    white_2010 + log(median_rent_2010) + log(median_income_2010) + 
    log(total_population_2010)
  
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

m_col_edu <- run_models(college_educated_2015 ~ .)
m_white <- run_models(white_2015 ~ .)
m_male <- run_models(male_2015 ~ .)
m_married <- run_models(married_2015 ~ .)
m_rent <- run_models(log(median_rent_2015) ~ .) # weak / nonsig association with gay!
m_inc <- run_models(log(median_income_2015) ~ .)

m_list <- list(
  m_col_edu = m_col_edu, 
  m_white = m_white, 
  m_male = m_male, 
  m_married = m_married, 
  m_rent = m_rent, 
  m_inc = m_inc
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



# ----

library(rstanarm)
m2_b <- stan_glm(f2, data = d)
# multilevel model is too slow to run
# mlm <- stan_glmer(college_educated_2015 ~ college_educated_2010 + (1|city), data = d)
# ml_m2_b <- stan_lmer(update(f2, . ~ . + (1 | city)), data = d)
