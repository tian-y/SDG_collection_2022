rm(list = ls())
load("YTreviewTemp/SDG_reporting/sdg_statslaw_statsplanImplementation.rds")
ctgap <- df_sdg %>% select(-key)
rm(df_sdg)

path_2021 = "YTreviewTemp/SDG_Reporting/2021/"
# rm(list = ls())

files_to_read = paste0(path_2021, "regional grouping.RData") 
load(files_to_read)
rm(files_to_read)

###### 
# list_of_indicators = list.files()[9:15]
# list_of_indicators = c(list_of_indicators, "17.18.3_government_new.csv")
# save(list_of_indicators, file = "files_to_work_on.rds")
files_to_read = paste0(path_2021, "files_to_work_on.rds")
load(files_to_read)
rm(files_to_read)
# list_of_indicators = list_of_indicators[7]

# file_to_read = "17.18.3_government_new.csv"

data_2021 <- list()

for (i in 1:length(list_of_indicators)) {
  file_to_read = list_of_indicators[i] 
  file_to_read <- paste0(path_2021, file_to_read)
  indicator_no <- gsub(pattern = ".csv", replacement = "", list_of_indicators[i] )
  original_data <-  read.csv(file_to_read, stringsAsFactors = F) 
  # assign(list_of_indicators[i],original_data)
  data_lean = original_data %>%
    select(code = GeoAreaCode, name = GeoAreaName,year = TimePeriod, value = Value) %>%
    mutate(value = as.numeric(value)) %>%
    mutate(value = ifelse(is.na(value),NA, value) ) %>%
    select(-name) %>%
    mutate(indicator = indicator_no)
  data_2021[[i]] <- data_lean
  rm(data_lean, original_data)
  # assign(list_of_indicators[i],data_lean)
  
  # names(original_data)
  # original_data_remove_grouping = original_data %>%
  #   filter(TimePeriod ==2019 |
  #            (GeoAreaCode %in% regionsCountries$code)
  #          )
  # names(original_data_remove_grouping)
  # names(group_by_reg)
  # 
  # ### special case 
  # 
  # if(indicator_name == "17.19.1") {
  #   group_by_reg = group_by_reg %>%
  #     rename(`2020` = `2018`)
  #   }
  # 
  # grouped_results = group_by_reg %>%
  #   select(GeoAreaCode = regioncode, GeoAreaName = region, Value = `2020`) %>%
  #   mutate(TimePeriod = 2020,  Time_Detail = 2020)
  # grouped_results_other_columns = original_data_remove_grouping %>% select(-(4:8)) %>% slice(1:nrow(grouped_results))
  # 
  # 
  # 
  # if(indicator_name == "17.19.1") {
  #   grouped_results = grouped_results %>% 
  #     mutate(TimePeriod = 2018, Time_Detail = 2018)
  #   }
  # 
  # grouped_results_full = cbind(grouped_results, grouped_results_other_columns)
  # 
  # rm(grouped_results, grouped_results_other_columns)
  # 
  # results_new = rbind(original_data_remove_grouping, grouped_results_full)
  # 
  # rm(original_data_remove_grouping, grouped_results_full)
  # 
  # rm(dat_lean_with_region, data_lean)
  # 
  # rm(group_by_reg)
  # 
  # rm(original_data)
  # # results_new %>% filter(TimePeriod == 2019) %>% nrow
  # 
  # write.csv(results_new, file = paste0(sys.Date(), indicator_name, ".csv"), row.names = F)
  # 
  # rm(results_new)
  # print(indicator_name)
}
data_2021 <- bind_rows(data_2021)  
# data_2021$ref = row.names(data_2021)

df_with_countrynames <- regions %>%
  select(code, name) %>%
  unique %>%
  # mutate(iso = countrycode(name, "country.name", "iso3n"))%>%
  inner_join(data_2021) 
# the codes are actually iso3n 

# some country groupings were lost in this process. This is ok because we want to remove them
# data_leftover = data_2021 %>%
#   filter(! ref %in% data_with_countrynames$ref)
# which(df_with_countrynames$code != df_with_countrynames$iso)

df_2020 <- df_with_countrynames %>% filter(year == 2020) %>%
  filter(indicator %in% c("17.18.2", "17.18.3_implement"))  %>%
  select(code, indicator, y2020 = value)

ctgap_long <- ctgap %>%
  mutate(code = countrycode(iso, "iso3c", "iso3n")) %>%
  select(-iso) %>%
  rename(`17.18.2` = statlaw, 
         `17.18.3_implement` = plan) %>%
  gather(key = indicator, value = y2021, -code)

df_2020_correctedby_2021 <- right_join(ctgap_long, df_2020) %>%
  mutate(y2021_new = ifelse(is.na(y2021), y2020, y2021))



df_2021 <- df_2020_correctedby_2021 %>%
  select(code, indicator, value = y2021_new) %>%
  mutate(year = 2021)
rm(df_2020_correctedby_2021, df_2020)
# names(df_with_countrynames)





df_2020_otherindicators_to2021 <- df_with_countrynames %>%
  select(-name) %>%
  filter(!indicator %in% c("17.18.2", "17.18.3_implement")) %>%
  filter(year == 2020) %>%
  mutate(year = 2021) 


df_history_to_2021 <- df_with_countrynames %>%
  select(-name) %>%
  rbind(df_2021, df_2020_otherindicators_to2021) 


df_history_to_2021 %>%
  filter(indicator == "17.18.2") %>%
  spread(year, value) %>%
  mutate(diff = `2021`==`2020`) %>%
  filter(!diff) %>%
  filter(`2021` ==0) %>%
  mutate(name = countrycode(code, "iso3n", "country.name"), 
         continent = countrycode(code, "iso3n", "un.region.name"))

country_to_change <- c("Cyprus", 
                       "Finland", 
                       "Hungary", 
                       "India", 
                       "Israel", 
                       "Kwait", 
                       "Indonesia", 
                       "Côte d’Ivoire", 
                       "Mexico", 
                       "Pakistan", 
                       "Senegal", 
                       "Slovakia", 
                       "Surinam", 
                       "United Arab Emirates", 
                       "Turkey", 
                       "Uzbekistan")
df_replace <- df_history_to_2021 %>%
  filter(indicator == "17.18.2") %>%
  spread(year, value) %>%
  mutate(diff = `2021`==`2020`) %>%
  filter(!diff) %>%
  filter(`2021` ==0) %>%
  mutate(name = countrycode(code, "iso3n", "country.name"), 
         continent = countrycode(code, "iso3n", "un.region.name"))%>%
  # mutate(`2021` = ifelse(name %in% country_to_change, 1, `2021`)) %>%
  filter(name %in% country_to_change) %>%
  select(code, indicator
         # , value = `2021`
  ) %>%
  mutate(year = 2021) 

df_history_to_2021_withoutreplace <- anti_join(df_history_to_2021, df_replace)

df_replace$value = 1


df_history_to_2021_updated <- rbind(df_history_to_2021_withoutreplace, df_replace) 



df_history_to_2021 <- df_history_to_2021_updated
# group_by_reg = dat_lean_with_region %>%
#   # filter(value == "1") %>%
#   group_by(regioncode, region, year)  %>%
#   dplyr::summarise(total = sum(value, na.rm = T)) %>%
#   spread(year, total)  %>%
#   as.data.frame
#
# for_annex = group_by_reg %>%
#   merge(order, by ="region", all.y = T ) %>%
#   arrange(order) %>%
#   select(-regioncode, -order) %>%
#   mutate(region = region_official, region_official = NULL)
# indicator_name = file_to_read %>% substr(1, nchar(file_to_read)-4)
# write.csv(for_annex, file = paste0(Sys.Date(),  indicator_name, "Group.csv"), row.names = F)
