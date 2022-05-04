# source("YTreviewTemp/SDG_reporting/3. merge press with data.R")

rm(list = ls())
file_name = "SDG_reporting_2021_new.rds"
path_to_read = "Code/SDG_reporting_working_2022/"
files_to_read = paste0(path_to_read, file_name)

df_data <-readRDS(files_to_read)

path_2021 = "Code/SDG_reporting_working_2022/2021/"
files_to_read = paste0(path_2021, "regional grouping.RData") 

load(files_to_read)
regionsCountries <-  regionsCountries %>%
  select(code, name) %>%
  unique()
rm(files_to_read)
rm(regionsMDG)
###### 
# list_of_indicators = list.files()[9:15]
# list_of_indicators = c(list_of_indicators, "17.18.3_government_new.csv")
# save(list_of_indicators, file = "files_to_work_on.rds")


df_sdg = df_data


df_sdg_sub_set <- df_sdg %>%
  filter(year %in% c( 2021)) %>%
  filter(!indicator %in% c("17.18.2", "17.19.1")) %>%
  spread(indicator, value) %>%
  # mutate(`17.18.3_implement_new` = ifelse(`17.18.3_funded`==1&(!is.na(`17.18.3_funded`)) , 1,`17.18.3_implement` )) %>%
  mutate(`17.18.3_government_new` = ifelse(`17.18.3_funded`==1 , 1,`17.18.3_government`)) %>%
  # mutate(`17.18.3_donor_new` = ifelse(`17.18.3_funded`==1 , 1,`17.18.3_donor`)) %>%
  # mutate(`17.18.3_other_new` = ifelse(`17.18.3_funded`==1 , 1,`17.18.3_other`)) %>%
  gather(key = indicator, value = value, -year, -code, na.rm = F)

df_sdg_rest <- df_sdg %>%
  filter(!(year==2021 & (!(indicator %in% c("17.18.2", "17.19.1")))) )
df_sdg <- rbind(df_sdg_sub_set, df_sdg_rest)


df_sdg_with_region = inner_join(regions,df_sdg) # also without regional groupings



df_group_by_reg = df_sdg_with_region  %>%
  # filter(value == "1") %>%
  group_by(regioncode, region, year, indicator)  %>%
  dplyr::summarise(total = sum(value, na.rm = T)) %>%
  spread(year, total)  %>%
  as.data.frame 
df_for_annex = df_group_by_reg %>%
  right_join(order) %>%
  arrange(order) %>%
  select(-order) %>%
  rename(code = regioncode) %>%
  mutate(name = region_official) %>%
  select(-region_official, -region) %>%
  gather(key = year, 
         value = value, 
         -name, 
         -code,
         -indicator, 
         convert = T)


df_press_world = df_data %>%
  filter(indicator == "17.19.1", 
         code == 1) %>%
  spread(year, value) %>%
  mutate(name = "World") %>%
  gather(key = year, 
         value = value, 
         -name, 
         -code, 
         -indicator, 
         convert = T)

df_for_annex= df_press_world %>% 
  select(-value) %>%
  anti_join(x = df_for_annex) %>%
  rbind(df_press_world)


df_for_annex_wide <-df_for_annex %>%
  spread(year, value) 

names(df_sdg)
df_individuals <-  df_sdg %>%
  filter(code %in% regionsCountries$code) %>%
  spread(key = year,value =  value) %>%
  right_join(regionsCountries) 


df_total = rbind(df_individuals, df_for_annex_wide)

# df_individuals %>% slice(5328, 5416, 5392, 5403, 6002, 6005
#                          , 5442, 5444
#                          , 5726, 5728
#                          , 5827, 5833)

files_to_read = paste0(path_2021, "files_to_work_on.rds")
load(files_to_read)
rm(files_to_read)
i = 5
i = 3
i = 7
toskip = T

indicator_toselect <- substr(list_of_indicators[i], 1,nchar(list_of_indicators[i])-4 )
original_data <- df_total %>%
  filter(indicator == indicator_toselect) 
data_lean <- original_data %>%
  select(-indicator) 

df_reg_sum <- data_lean %>% 
  filter(!code %in% regionsCountries$code) %>%
  gather(key = year, value = value, -code, -name) %>%
  filter(!is.na(value)) %>%
  spread(year, value)



