rm(list = ls())
source("code/boot.R")
df_sdg_1718   <- readRDS(paste0("Data/",
                                year(Sys.Date()),
                                "/10.2 17.18 correcting errors.RDS"))

df_sdg <- readRDS(paste0("Data/",
                         year(Sys.Date()),
                         "/08. full 17.18 data without regional aggregation.RDS"))

df_sdg <- df_sdg %>% 
  # select(m49, year, indicator:region_code) %>% 
  select(-value) %>% 
  unique %>% 
  left_join(df_sdg_1718) %>% 
  rename(value  =  total)


df_sdg_region <- df_sdg %>% 
  # rename(year = reportedyear) %>% 
  filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  group_by(region_code, year, indicator
           , region_type
  ) %>% 
  summarise(total = sum(value, na.rm = T)) %>% 
  ungroup() %>% 
  rename(m49 = region_code) 

df_sdg_region_nas <- df_sdg %>% 
  # rename(year = reportedyear) %>% 
  filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  group_by(region_code, year, indicator
           , region_type) %>% 
  mutate(obs  = n()) %>% 
  group_by(region_code, year, indicator
           , region_type, value, obs
  ) %>% 
  summarise(cnt_na = n()) %>% 
  filter(is.na(value)) %>% 
  filter(cnt_na == obs) %>% 
  ungroup() %>% 
  select(region_code, year, indicator) %>% 
  unique %>% 
  mutate(to_replace_with_na = T) %>% 
  rename(m49 = region_code)


df_sdg_region <- df_sdg_region %>% 
  arrange(indicator, year, m49, region_type) %>% 
  group_by(indicator, year, m49) %>% 
  filter(!duplicated(m49)) 

df_sdg_region <- df_sdg_region %>% 
  left_join(df_sdg_region_nas) %>% 
  mutate(total = ifelse(is.na(to_replace_with_na), total, NA)) %>% 
  select(-to_replace_with_na) 

rm(df_sdg_region_nas)
  

df_sdg_country <- df_sdg %>% 
  # rename(year = reportedyear) %>% 
  filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  filter(!is.na(m49)) %>% 
  select(m49, year, indicator, value) %>% 
  unique %>% 
  rename(total = value)
# group_by(m49, year, indicator)  %>% 
# summarise(total  = sum(value, na.rm = T)) 

df_sdg_country %>% 
  select(m49, year, indicator) %>% 
  unique %>% 
  nrow

df_sdg_country %>% 
  group_by(year, indicator) %>% 
  summarise(cnt = n()) %>% 
  as.data.frame()

df_sdg_world <- df_sdg %>% 
  # rename(year = reportedyear) %>% 
  filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  filter(!is.na(m49)) %>% 
  # group_by(id) %>% 
  # filter(row_number()==1) %>% 
  select(year, indicator, m49, value) %>%
  unique() %>% 
  # group_by(year, indicator, m49) %>% 
  # filter(row_number()==1) %>%
  group_by(year, indicator)  %>% 
  summarise(total  = sum(value, na.rm = T), cnt = n()) %>% 
  ungroup() %>% 
  mutate(m49 = 1)

df_sdg_region <- df_sdg_region %>% 
  select(-region_type)

df_sdg_world <- df_sdg_world %>% 
  select(-cnt)

df_sdg_reporting <- rbind(df_sdg_world, 
                          df_sdg_region, 
                          df_sdg_country)  #%>% 

df_sdg_reporting %>% 
  rename(total_new = total) %>% 
  mutate(marker = 1) %>% 
  right_join(df_sdg_1718) %>% 
  filter(is.na(marker)) %>% 
  as.data.frame()


# filter(year < 2021) %>% 
# mutate(indicator = "17.19.1")

saveRDS(df_sdg_reporting, file = paste0("Data/",
                                        year(Sys.Date()),
                                        "/10.3 17.18 re-regional after correcting errors.RDS"))

