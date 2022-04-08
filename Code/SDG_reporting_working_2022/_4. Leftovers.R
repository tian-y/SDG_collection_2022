for (i in 1:length(list_of_indicators)) {
  
  indicator_toselect <- substr(list_of_indicators[i], 1,nchar(list_of_indicators[i])-4 )
  original_data <- df_data %>%
    filter(indicator == indicator_toselect) 
  data_lean <- original_data %>%
    select(-indicator)
  
  if(indicator_toselect!= "17.19.1") {
    data_lean %>%
      spread(year, value) %>%
      mutate(diff = `2021`==`2020`) %>%
      filter(!diff) %>%
      mutate(name = countrycode(code, "iso3n", "country.name"))
  }
  
  # data_lean = original_data %>%
  #   select(code = GeoAreaCode, name = GeoAreaName,year = TimePeriod, value = Value) %>%
  #   mutate(value = as.numeric(value)) %>%
  #   mutate(value = ifelse(is.na(value),NA, value) ) %>%
  #   select(-name)
  names(data_lean)
  names(regions)
  
  
  
  dat_lean_with_region = inner_join(regions,data_lean) # previously it was left join
  # which(dat_lean_with_region$year %>% is.na())
  group_by_reg = dat_lean_with_region %>%
    # filter(value == "1") %>%
    group_by(regioncode, region, year)  %>%
    dplyr::summarise(total = sum(value, na.rm = T)) %>%
    spread(year, total)  %>%
    as.data.frame 
  
  for_annex = group_by_reg %>%
    merge(order, by ="region", all.y = T ) %>%
    arrange(order) %>%
    select(-regioncode, -order) %>%
    mutate(region = region_official, region_official = NULL)
  
  if(!toskip) {
    write.csv(for_annex, file = paste0( indicator_toselect, "Group.csv"), row.names = F)
  } 
  
  names(original_data)
  # this is a very strange step
  original_data_only_specifics = original_data %>%
    select(-indicator) %>%
    inner_join(regionsCountries)
  
  # mutate(TimePeriod = year, Time_Detail = year) %>%
  # select(-year)
  names(original_data_remove_grouping)
  names(group_by_reg)
  
  ### special case 
  
  # if(indicator_toselect == "17.19.1") {
  #   group_by_reg = group_by_reg %>%
  #     rename(`2020` = `2018`)
  # }
  
  grouped_long = group_by_reg %>%
    gather(key = year, value = value, -regioncode, -region, 
           convert = T) %>%
    rename(code = regioncode, name = region) # %>%
  
  # mutate(TimePeriod = year, Time_Detail = year) %>%
  # select(-year)
  # setdiff(grouped_results, original_data_only_specifics)
  
  # grouped_results = group_by_reg %>%
  #   select(GeoAreaCode = regioncode, GeoAreaName = region, Value = `2019`) %>%
  #   mutate(TimePeriod = 2021,  Time_Detail = 2021)
  # grouped_results_other_columns <-  original_data_remove_grouping # %>% 
  # select(-(4:8)) %>% 
  # slice(1:nrow(grouped_results))
  
  
  # 
  # if(indicator_toselect == "17.19.1") {
  #   grouped_results = grouped_results %>% 
  #     mutate(TimePeriod = 2019, Time_Detail = 2019)
  # }
  # 
  df_results_full = rbind(grouped_long, original_data_only_specifics)
  
  rm(grouped_long, original_data_only_specifics)
  
  results_new = rbind(original_data_remove_grouping, grouped_results_full)
  
  rm(original_data_remove_grouping, grouped_results_full)
  
  rm(dat_lean_with_region, data_lean)
  
  rm(group_by_reg)
  
  rm(original_data)
  # results_new %>% filter(TimePeriod == 2019) %>% nrow
  
  write.csv(results_new, file = paste0(indicator_toselect, "_20210503.csv"), row.names = F)
  
  rm(results_new)
  print(indicator_toselect)
}

