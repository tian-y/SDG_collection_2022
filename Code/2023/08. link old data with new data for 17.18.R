rm(list = ls())
gc()
df_sdg <- readRDS("data/2023/05. ext the survey data_simpliefied.RDS")
df_past1 <- readRDS("code/SDG_reporting_working_2022/SDG_reporting_2021_new.rds")
attributes(df_past1)$description <- "new"
df_past2 <- readRDS("code/SDG_reporting_working_2022/SDG_reporting_2021.rds")
attributes(df_past2)$description <- "no new"
df_past3 <- readRDS("code/SDG_reporting_working_2022/sdg_statslaw_statsplanImplementation.rds")
attributes(df_past3)$description <- "statslaw statsplanimplementation"

df_past <- df_past1 %>% 
  rename(value1 = value) %>% 
  inner_join(rename(df_past2, value2 = value)) 


df_past %>% 
  filter(value1 != value2  ) 

df_past %>% 
  filter(is.na(value1), !is.na(value2))

df_past %>% 
  filter(!is.na(value1), is.na(value2))

df_past %>% 
  filter(value1 != value2  ) %>% 
  mutate(country = countrycode(code, "iso3n", "country.name"))

df_sdg %>% 
  filter(m49 == 384)



df_past <- df_past1 %>% 
  rename(m49 = code) %>% 
  filter(indicator!= "17.19.1")

unique(df_past$indicator) 
unique(df_sdg$indicator)

df_indicator_names <- tibble(indicator_past = unique(df_past$indicator) , 
                             indicator = c("statlaw", 
                                           "nsds_don", 
                                           "nsds_funded",
                                           NA, 
                                           "nsds_implement", 
                                           "nsds_other", 
                                           "nsds_gov"))

df_past <- df_past %>% 
  rename(indicator_past = indicator) %>% 
  inner_join(df_indicator_names)

rm(df_indicator_names, df_past1, df_past2, df_past3)

df_past %>% 
  select(year) %>% 
  table

df_sdg %>%  
  select(year) %>% 
  table

df_region_code <- readRDS("Data/Auxiliary/region_code.RDS") 
df_country_code <- df_region_code %>% 
  select(m49) %>% 
  # mutate(country = 1) %>% 
  unique

df_past <- df_past %>% 
  left_join(df_country_code)

df_sdg %>% 
  filter(!m49 %in% df_country_code$m49) %>% 
  mutate(country = countrycode(m49, "iso3n", "country.name"))

df_sdg_since2019 <- df_past %>% 
  select(-indicator_past) %>% 
  rbind(rename(df_sdg, value = value_final))


df_sdg_since2019 <- df_sdg_since2019 %>% 
  inner_join(df_region_code)

save(df_sdg_since2019, file = "data/2023/08. full 17.18 data without regional aggregation.RDS")

df_sdg_since2019 %>% 
  select(m49, indicator, year) %>% 
  unique %>% 
  nrow







