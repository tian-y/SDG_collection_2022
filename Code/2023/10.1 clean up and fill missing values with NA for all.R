rm(list = ls())
source("code/boot.R")
## working on 17.18
df_sdg_reporting_regions <- readRDS("data/2023/09 17.18 ready raw data.RDS")

df_sdg_1718 <- df_sdg_reporting_regions %>% 
  spread(key = year, value = total, fill = NA) %>% 
  gather(key = "year", value = total, -indicator, -m49) %>% 
  mutate(year = as.numeric(year))

df_sdg_1718 %>% 
  group_by(year) %>% 
  summarise(cnt = n())

df_sdg_1718 <- df_sdg_1718 %>% 
  mutate(total = as.integer(total))

df_sdg_1718 %>% 
  saveRDS("data/2023/10. 17.18 filling missing values.RDS")

rm(df_sdg_reporting_regions)

df_sdg_1719 <- readRDS("data/2023/07 17.19.1 ready raw data.RDS")

df_entity_code <- df_sdg_1718 %>% 
  select(m49) %>% 
  unique

df_sdg_1719 <- df_sdg_1719 %>% 
  filter(year > 2010, year< 2021) 

df_sdg_1719 <- df_sdg_1719 %>% 
  #### !!!! this step will create some rows with empty year values and will affect the reshaping, so make sure to remove those entries before shaping wide to long
  right_join(df_entity_code) %>% 
  spread(key = year, value = total) %>% 
  gather(key = "year", value = total, 
         -m49, -indicator)  %>% 
  mutate(year = as.numeric(year)) %>% 
  filter(!is.na(year))

df_sdg_1719 %>% 
  group_by(year) %>% 
  summarise(cnt = n())


df_sdg_1719 <- df_sdg_1719 %>% 
  mutate(total = ifelse(total == 0, NA, total))


df_sdg_1719 %>% 
  saveRDS("data/2023/10. 17.19 filling missing values.RDS")


