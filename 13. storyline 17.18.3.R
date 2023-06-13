rm(list = ls())
source("code/boot.R")
df_sdg_1718   <- readRDS("Data/2023/10.2 17.18 correcting errors.RDS")

df_sdg <- readRDS("data/2023/08. full 17.18 data without regional aggregation.RDS")

df_sdg <- df_sdg %>% 
  select(m49, year, indicator:region_code) %>% 
  unique %>% 
  left_join(df_sdg_1718) %>% 
  rename(value  =  total)

rm(df_sdg_1718)
df_sdg_region <- df_sdg %>% 
  filter(indicator %in% c("nsds_implement", "nsds_funded")) %>% 
  filter(region_type %in% c("sdg_region", "ldc", "lldc")) %>% 
  # rename(year = reportedyear) %>% 
  # filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  group_by(region_code,
           # year, 
           indicator
           , region_type
           , value
  ) %>% 
  summarise(total = n()) %>% 
  ungroup() %>% 
  rename(m49 = region_code) 

df_sdg_region <- df_sdg_region %>% 
  mutate(value_text = ifelse(is.na(value), 
                             "Information not available", 
                             ifelse(value==1, 
                                    "Yes", 
                                    "No")))


df_sdg_region <- df_sdg %>% 
  filter(indicator %in% c("nsds_implement", "nsds_funded")) %>%
  # filter(year == 2022) %>% 
  filter(region_type %in% c("sdg_region", "ldc", "lldc")) %>% 
  spread(key = indicator, value = value) %>% 
  select(-region_type)

df_sdg_region %>% 
  filter(nsds_funded ==1 , nsds_implement!=1|is.na(nsds_implement))

df_sdg_region %>% 
  # filter(year == 2022)  %>% 
  # filter(iso == "LUX") %>% 
  filter(nsds_funded ==0 , nsds_implement==1
         # , region_code == 531
         ) %>% 
  select(iso, nsds_funded, nsds_implement
         , year
         ) %>% 
  unique %>% 
  mutate(countryname = countrycode(iso, "iso3c","country.name"))
  # rename(year = reportedyear) %>% 
  # filter(indicator != "nsds_none" , indicator != "nsds_exist") %>% 
  # group_by(region_code,
  #          # year, 
  #          indicator
  #          , region_type
  #          , value
  # ) %>% 
  # summarise(total = n()) %>% 
  # ungroup() %>% 
  # rename(m49 = region_code) 
  
df_sdg_region <- df_sdg_region %>% 
  mutate(new_value = ifelse(nsds_funded == 1 & !is.na(nsds_funded), 
                            "fully funded", 
                            ifelse(nsds_implement == 1 & !is.na(nsds_implement), 
                                   "under implementation", 
                                   ifelse(nsds_implement == 0 & !is.na(nsds_implement), 
                                          "not implementing", 
                                          ifelse(is.na(nsds_implement),
                                                 "unknow implementation", "outliers")))))

df_sdg_region %>% 
  select(new_value) %>% 
  table

df_sdg_region %>% 
  filter(is.na(new_value))

df_sdg_region %>% 
  filter(new_value == "outliers")

df_sdg_region %>% 
  filter(m49 == region_code)

df_storyline <- df_sdg_region %>% 
  filter(year == 2022) %>% 
  filter(!m49 %in% c(74, 680)) %>% 
  filter(!is.na(m49)) %>% 
  select(region_code, new_value, m49) %>% 
  unique() %>% 
  group_by(region_code, new_value) %>% 
  summarise(total = n()) %>% 
  ungroup %>% 
  spread(key = new_value, value = total, fill = 0)  %>% 
  mutate(sum = rowSums(across(`fully funded`:`unknow implementation`)))

df_order <- read_csv("data/Auxiliary/Regional_grouping_storyline_order fixed.csv")

df_storyline <- df_storyline %>% 
  rename(GeoAreaCode = region_code) %>% 
  left_join(df_order) %>% 
  arrange(desc(Order)) 
  


df_storyline <- df_storyline %>% 
  select(Region = GeoAreaName
         , `Under implementation and fully funded` = `fully funded`
         , `Under implementation and not fully funded` = `under implementation`
         , `Not implementing` = `not implementing`
         , `Information not available` = `unknow implementation`)


write_csv(df_storyline, file = "output/2023/storyline_17.18.3.csv")
  

