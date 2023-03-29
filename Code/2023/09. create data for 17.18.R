rm(list = ls())
gc()

df_sdg <- readRDS("data/2023/08. full 17.18 data without regional aggregation.RDS")

df_sdg_region <- df_sdg %>% 
  # rename(year = reportedyear) %>% 
  filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  group_by(region_code, year, indicator) %>% 
  summarise(total = sum(value, na.rm = T)) %>% 
  ungroup() %>% 
  rename(m49 = region_code) 


df_sdg_country <- df_sdg %>% 
  # rename(year = reportedyear) %>% 
  filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  filter(!is.na(m49)) %>% 
  group_by(m49, year, indicator)  %>% 
  summarise(total  = sum(value, na.rm = T)) 

df_sdg_world <- df_sdg %>% 
  # rename(year = reportedyear) %>% 
  filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  # group_by(id) %>% 
  # filter(row_number()==1) %>% 
  group_by(year, indicator, m49) %>% 
  filter(row_number()==1) %>% 
  filter(!is.na(m49)) %>% 
  group_by(year, indicator)  %>% 
  summarise(total  = sum(value, na.rm = T)) %>% 
  ungroup() %>% 
  mutate(m49 = 1)

df_sdg_reporting <- rbind(df_sdg_world, 
                    df_sdg_region, 
                    df_sdg_country)  #%>% 
  # filter(year < 2021) %>% 
  # mutate(indicator = "17.19.1")

saveRDS(df_sdg_reporting, file = "data/2023/09 17.8 ready raw data.RDS")

