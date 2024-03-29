rm(list = ls())
gc()
source("code/boot.R")

df_sdg <- readRDS("data/2023/06.2 17.19.1 data with region codes.RDS")

df_sdg_region <- df_sdg %>% 
  rename(year = reportedyear) %>% 
  group_by(region_code, year 
           , region_type
           ) %>% 
  summarise(total = sum(usd_disbursement_defl, na.rm = T)) %>% 
  ungroup() %>% 
  rename(m49 = region_code) 

df_sdg_region <- df_sdg_region %>% 
  arrange(year, m49, region_type) %>% 
  group_by(year, m49) %>% 
  filter(!duplicated(m49)) 

df_sdg_region <- df_sdg_region %>% 
  select(-region_type)


df_sdg_country <- df_sdg %>% 
  rename(year = reportedyear) %>% 
  group_by(id) %>%
  filter(row_number()==1) %>%
  filter(!is.na(m49)) %>% 
  # filter(is.na(region_type))
  # filter(region_type == "sdg_region") %>%
  group_by(m49, year)  %>% 
  summarise(total  = sum(usd_disbursement_defl, na.rm = T)) 

df_sdg_world <- df_sdg %>% 
  rename(year = reportedyear) %>% 
  group_by(id) %>% 
  filter(row_number()==1) %>% 
  # filter(!is.na(m49)) %>% 
  group_by(year)  %>% 
  summarise(total  = sum(usd_disbursement_defl, na.rm = T)) %>% 
  ungroup() %>% 
  mutate(m49 = 1)

df_17.19.1 <- rbind(df_sdg_world, 
                    df_sdg_region, 
                    df_sdg_country)  %>% 
  filter(year < 2021, year > 2009) %>% 
  mutate(indicator = "17.19.1")

saveRDS(df_17.19.1, file = "data/2023/07 17.19.1 ready raw data.RDS")

