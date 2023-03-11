rm(list = ls())


df_sdg2022 <- readRDS("Code/SDG_reporting_working_2022/SDG_reporting_2021_new.rds")

df_sdg2022 <- df_sdg2022 %>% 
  filter(year == "2021") %>% 
  select(-year) # %>% 
  # spread(key = indicator, value = value)

df_sdg2022 %>% 
  select(indicator) %>% 
  table

df_indicator <- tibble(indicator = c("17.18.2", 
                                     "17.18.3_implement", 
                                     "17.18.3_funded"), 
                       indicator_2023 = c("statlaw", 
                                          "nsds_implement", 
                                          "nsds_funded"))

df_sdg2022 <- df_sdg2022 %>% 
  inner_join(df_indicator) %>% 
  mutate(indicator = indicator_2023) %>% 
  select(-indicator_2023)


df_sdg2022 <- df_sdg2022 %>% 
  spread(key = indicator, value = value) %>% 
  gather(key = indicator, value = value, -code) %>%
  rename(m49 = code)

rm(df_indicator)


df_sdg <- readRDS("data/2023/03. adding country names and codes.Rds")


df_sdg <- df_sdg %>% 
  gather(key = indicator, value = value, -token, -m49, -country, -iso)


df_sdg2022_updated <- df_sdg2022 %>% 
  rename(value_2022 = value) %>% 
  left_join(df_sdg) %>% 
  rename(value_2023 = value)


df_sdg2022_updated <- df_sdg2022_updated %>% 
  mutate(value_final = ifelse(is.na(value_2023), value_2022, value_2023))

df_sdg2022_updated %>% 
  group_by(indicator, value_final) %>% 
  summarise(total = n())

df_sdg2022_updated %>% 
  group_by(indicator, value_2022) %>% 
  summarise(total = n())


saveRDS(df_sdg2022_updated, file = "Data/2023/04.1 update use previous year's reporting.RDS")
