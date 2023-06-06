rm(list = ls())

df_region_code <- readRDS("data/Auxiliary/region_code.RDS")
df_regions <- df_region_code %>% 
  select(region_type, region_code) %>% 
  unique

df_sdg_reporting_regions <- readRDS("data/2023/09 17.8 ready raw data.RDS")
df_sdg_country_only <- readRDS("data/2023/08. full 17.18 data without regional aggregation.RDS")


#### find out about wether ddf_sdg_country_only only has countries
df_sdg_country_only %>% 
  filter(m49 == region_code) %>% 
  unique
#### yes


##### find out about wether df_sdg_reporting_regions only has regions
df_sdg_reporting_regions  %>% 
  filter(!(m49 %in% df_regions$region_code)) %>% 
  select(m49) %>% 
  unique
##### no, also found out df_regions don't have world total

##### to confirm the tabulation
df_sdg_reporting_regions %>% 
  select(year, indicator) %>% 
  table
#### find out that 2022 has two more obs, let's see what it is

df_sdg_reporting_regions %>% 
  group_by(m49) %>% 
  summarise(cnt = n()) %>% 
  arrange((cnt)) %>% 
  head(20)
#### find out it's code 74 and 680, who are they?
df_region_code %>% 
  filter(region_code == 74 | region_code == 680)
#### they are not regions
df_region_code %>% 
  filter(m49 == 74 | m49 == 680)
#### it's bvt and sth else
df_country <- read_csv("data/Auxiliary/m49code.csv")
df_country %>% 
  filter(m49 %in% c(74, 680)) %>% 
  select()
#### from https://unstats.un.org/unsd/methodology/m49/
#### we found out that 74 is bouvet island and 680 is Sark
rm(df_country)
rm(df_sdg_country_only)
rm(df_regions, df_region_code)


df_sdg_reporting_regions_fill_missing <- df_sdg_reporting_regions %>% 
  spread(key = year, value = total, fill = NA) %>% 
  gather(key = "year", value = total, -indicator, -m49)


saveRDS(df_sdg_reporting_regions_fill_missing, file = "")


