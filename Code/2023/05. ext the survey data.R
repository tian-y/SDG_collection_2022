rm(list = ls())

df_sdg <- readRDS("data/2023/04.4 adding nsds table for implementation status.RDS")

names(df_sdg)

df_sdg <- df_sdg %>% 
  mutate(value_final = NA) %>% 
  mutate(value_final = ifelse(is.na(value_2023), value_nsds_status_table, value_2023)) %>% 
  mutate(value_final = ifelse(is.na(value_2023), value_ctgap, value_2023)) %>% 
  mutate(value_final = ifelse(is.na(value_2023), value_2022, value_2023))

df_sdg %>% 
  ungroup() %>% 
  select(indicator, value = value_final) %>% 
  mutate(count = 1) %>% 
  pivot_wider(names_from = "indicator", 
              values_from = "count", 
              values_fn = sum) %>% 
  filter(!is.na(value)) %>% 
  # print %>%
  arrange(value)


df_sdg %>% 
  ungroup() %>% 
  select(indicator, value_2023) %>% 
  mutate(count = 1) %>% 
  pivot_wider(names_from = "indicator", 
              values_from = "count", 
              values_fn = sum) %>% 
  filter(!is.na(value_2023)) %>% 
  # print %>% 
  arrange(value_2023)



df_sdg %>% 
  ungroup() %>% 
  select(indicator, value = value_2022) %>% 
  mutate(count = 1) %>% 
  pivot_wider(names_from = "indicator", 
              values_from = "count", 
              values_fn = sum) %>% 
  filter(!is.na(value) )%>% 
  # print %>% 
  arrange(value)


saveRDS(df_sdg, file = "Data/2023/05. ext the survey data.RDS")

