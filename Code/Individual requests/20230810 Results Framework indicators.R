library(tidyverse)
library(countrycode)
library(zoo)

df_sdg <- readRDS("data/2023/10 all SDG ready to be reported in the simplest format.RDS")

df_income <- readxl::read_xlsx("data/Auxiliary/income class.xlsx") 

df_income <- df_income %>% 
  filter(`Income group` == "Low income" | `Income group`=="Lower middle income") %>% 
  mutate(m49 = countrycode(Economy, "country.name", "iso3n")) %>% 
  filter(!is.na(m49)) 

vec_lmic <- df_income$m49

# vec_gac_countries <- readLines("data/Auxiliary/GAC countries.txt")
df_countries <- tibble(country = vec_gac_countries) %>% 
  mutate(m49 = countrycode(country, "country.name", "iso3n"))

df_ida <- read_csv("~/dropbox/PARIS21/R/PRESS/Data/auxiliary/IDA status.csv")
df_ida_long_reduced <- df_ida %>% 
  rename(country = Economy, iso = Code) %>% 
  gather(key = "year", value = "ida", -country, -iso) %>% 
  mutate(m49 = countrycode(iso, "iso3c", "iso3n")) %>% 
  mutate(year = as.numeric(year)) %>% 
  filter(iso != "XKX") %>% 
  filter(ida == 1) %>% 
  select(-ida) %>% 
  select(-iso, -country)


df_sdg %>%  
  filter(m49 %in% vec_lmic) %>% 
  filter(indicator == "statlaw") %>% 
  # inner_join(df_countries) %>% 
  group_by(year) %>% 
  summarise(total = sum(total, na.rm = T))

df_sdg %>% 
  filter(m49 %in% vec_lmic) %>% 
  filter(indicator == "statlaw") %>% 
  select(-indicator) %>% 
  spread(key = year, value = total) %>% 
  filter(`2022` != `2021`) %>% 
  mutate(country = countrycode(m49, "iso3n", "country.name"))

df_sdg %>%  
  filter(m49 %in% vec_lmic) %>% 
  filter(indicator == "17.19.1") %>% 
  # inner_join(df_countries) %>% 
  group_by(year) %>% 
  summarise(total = sum(total, na.rm = T)) %>% 
  mutate(total_3yr = rollapply(total, width = 3, FUN = sum, align = "right", fill = NA))

df_sdg %>% 
  filter(m49 %in% vec_lmic) %>% 
  filter(indicator == "nsds_funded") %>% 
  select(-indicator) %>% 
  spread(key = year, value = total) %>% 
  filter(`2022` != `2021`) %>% 
  mutate(country = countrycode(m49, "iso3n", "country.name"))


df_sdg %>%  
  filter(m49 %in% vec_lmic) %>% 
  filter(indicator == "nsds_funded") %>% 
  # inner_join(df_countries) %>% 
  group_by(year) %>% 
  summarise(total = sum(total, na.rm = T))


df_sdg %>% 
  filter(indicator == "17.19.1") %>% 
  inner_join(df_countries) %>% 
  group_by(year) %>% 
  summarise(total = sum(total, na.rm = T)) %>% 
  mutate(total_3yr = rollapply(total, width = 3, FUN = sum, align = "right", fill = NA))

df_sdg %>% 
  filter(indicator == "17.19.1") %>% 
  inner_join(df_ida_long_reduced)  %>% 
  group_by(year) %>% 
  summarise(total = sum(total, na.rm = T)) %>% 
  mutate(total_3yr = rollapply(total, width = 3, FUN = sum, align = "right", fill = NA))


df_sdg %>% 
  filter(indicator == "nsds_funded") %>% 
  inner_join(df_countries) %>% 
  group_by(year) %>% 
  summarise(total = sum(total, na.rm = T))


df_sdg %>% 
  filter(indicator == "nsds_implement") %>% 
  inner_join(df_countries) %>% 
  as.data.frame
  group_by(year) %>% 
  summarise(total = sum(total, na.rm = T))
