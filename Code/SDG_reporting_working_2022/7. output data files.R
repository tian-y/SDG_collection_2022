source("Code/SDG_reporting_working_2022/4. produce reporting_new.R")

list_ins = unique(df_for_annex_wide$indicator) %>% as.character()
list_ins
# write_lines(list_ins, file = "Output/Output format 2022/list_indicators.csv")
# output_files = list.files(path = "Output/Output format 2022/ExcelTemplates_116/")
# write_lines(output_files, file ="Output/Output format 2022/output_files.txt" )
list_files = read_csv("Output/Output format 2022/indicator_to_files.csv") %>%
  filter(!is.na(ind_name_standard))
list_ins = list_ins[list_ins %in% list_files$ind_name_data]


regionsCountries_forReporting = regionsCountries %>%
  mutate(iso3c = countrycode(code, "iso3n", "iso3c")) %>%
  select(code, iso3c) %>%
  mutate(geo_type = "Country")%>%
  mutate(iso3c = ifelse(is.na(iso3c), "NULL", iso3c))


df_total <- regionsCountries_forReporting %>%
  right_join(df_total) %>%
  mutate(iso3c = ifelse(is.na(iso3c), "NULL", iso3c), 
         geo_type = ifelse(is.na(geo_type), "Region", geo_type))



standard_names <- read.csv("Output/Output format 2022/column_names.csv") 
standard_names <- standard_names %>%
  mutate(order_standard = 1:nrow(standard_names))
names(standard_names)

# load(file = "Code/SDG_reporting_working_2022/2021/regional grouping.RData")
i = "17.19.1"
# i = list_ins[1]
for (i in list_ins) {
  # if(i == "17.19.1")
  subset = df_total %>%
    filter(indicator == i)  %>%
    gather(key = year, value = value, -indicator, -name, -code, -iso3c, -geo_type) %>%
    mutate(year = as.numeric(year)) %>%
    mutate(year2 = year)
  annual_sum = subset %>%
    filter(!is.na(value)) %>%
    group_by(year) %>%
    summarise(cnt = n()) %>%
    .$year 
  
  if(i == "17.19.1") {
    subset <- subset %>%
      filter(year %in% annual_sum) 
  } else {
    subset <- subset %>%
      filter(year %in% annual_sum) %>%
      filter(year == max(annual_sum))
  }

  
  names_original = data.frame(var_name_set = names(subset), stringsAsFactors = F)
  names_original$order_dataset = 1:nrow(names_original)
  names_match = left_join(standard_names, names_original) %>% arrange(order_standard)
  names_match
  names(subset)
  subset <- subset %>%
    select(all_of(names_match$var_name_set))
  
  names(subset) = names_match[,1]
  
  file_to_read = list_files %>%
    filter(ind_name_data == i) %>%
    .$ind_name_standard
  file_to_save = paste0("output/2022/", file_to_read)
  file_to_read = paste0("output/Output format 2022/ExcelTemplates_116/", file_to_read)
  # file_to_save = paste0("output/2022/", file_to_read)
  output = readxl::read_xlsx( file_to_read, sheet = "Data") 
  output = output %>%
    mutate(Value = as.numeric(Value), 
           Time_Detail = as.numeric(Time_Detail))
  output_new = full_join(output, subset)
  
  output_fill = output %>%
    select(-all_of( names(subset))) %>% 
    unique
  if(nrow(output_fill)!=1) print("There are some columns you need to be careful of!")
  output_fill = output_fill %>% slice(rep(1, nrow(subset)))
  # head(output_fill)
  subset_full = cbind(output_fill, subset)
  names(subset_full)
  
  if(i == "17.19.1") {
    data = rbind(output[1,], subset_full) %>%
      slice(-1)
    data = data %>% filter(TimePeriod == 2019)
  } else {
    data = rbind(output, subset_full)
  }

  # is.na(data$Value)
  data = data%>% 
    mutate(Value = ifelse(is.na(Value), "NaN", Value))
  
  data = data %>% 
    mutate(Indicator = substr(Indicator, 1, 7))

  
  wb = openxlsx::loadWorkbook(file_to_read)
  
  if(i == "17.19.1") {
    openxlsx::removeWorksheet( wb, sheet = "Data")
    addWorksheet(wb , "Data")
  }

  writeData(wb, "Data", x = data)
  
  
  saveWorkbook(wb, file_to_save, overwrite = T)
  tail(data, 21) %>% print
  # tail(output_new) %>% print

  # df_name = paste0("indicator_", i)
  # write.csv(subset, file = paste0(df_name, ".csv"))
  # assign(df_name, subset)
}




