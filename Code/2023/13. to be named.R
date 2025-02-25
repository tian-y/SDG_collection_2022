rm(list = ls())
gc()

df_sdg <- readRDS(paste0("data/", 
                         year(Sys.Date()),
                         "/08. full 17.18 data without regional aggregation.RDS"))

df_sdg %>% 
  filter(year == 2023, indicator == "nsds_implement", region_code==202)

df_sdg_region <- df_sdg %>% 
  filter(indicator %in% c("nsds_implement", "nsds_funded")) %>% 
  filter(region_type %in% c("sdg_region", "ldc", "lldc")) %>% 
  # rename(year = reportedyear) %>% 
  # filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  group_by(region_code, year, indicator
           , region_type, value
  ) %>% 
  summarise(total = n()) %>% 
  ungroup() %>% 
  rename(m49 = region_code) 

df_sdg_region <- df_sdg_region %>% 
  arrange(indicator, year, m49, region_type) %>% 
  group_by(indicator, year, m49) %>% 
  filter(!duplicated(m49)) 
