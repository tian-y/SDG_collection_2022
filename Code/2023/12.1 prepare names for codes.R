# Reporting Requirements
## D-H: GeoAreaCode, GeoAreaName, TimePeriod, Value (NaN), Time_Detail
## N, O: ISOalpha3 (NULL), Type (Region or Country)

rm(list = ls())
source("Code/boot.R")
df_sdg <- readRDS("data/2023/10 all SDG ready to be reported in the simplest format.RDS")

df_code_country <- read_xlsx("document/Code to country names.xlsx")
df_code_region <- read_xlsx("document/Code to region names.xlsx")
df_code_MDG_only <- read_xlsx("document/Code to MDG only names.xlsx")
names(df_code_region) <- names(df_code_country)
names(df_code_MDG_only) <- names(df_code_country)
# df_code_names <- rbind(df_code_region, df_code_country)
df_code_names <- df_code_country
source("code/2023/12.1a test if all values are in the code_name list.R")
rm(df_code_MDG_only)
rm(df_code_country)

# 514 is Developed Regions in MDG

df_code_names <- df_code_names %>% 
  unique %>% 
  mutate(ISOalpha3 = countrycode(GeoAreaCode, "iso3n", "iso3c")) %>% 
  mutate(ISOalpha3 = ifelse(is.na(ISOalpha3), "NULL", ISOalpha3))

## checking if the list of names covers all the countries in df_sdg
df_code_names %>%
  saveRDS(file = "data/Auxiliary/m49 code and names.RDS")
# 

names(df_sdg)

df_sdg_reporting <- df_sdg %>%
  rename(GeoAreaCode = m49, Value = total, TimePeriod = year) %>%
  mutate(Time_Detail = TimePeriod) # %>%
  # mutate(Value = as.character(Value))
# names(df_sdg_reporting)
# names(df_code_names)
# is.numeric(df_code_names$GeoAreaCode)
# is.numeric(df_sdg_reporting$GeoAreaCode)

df_sdg_reporting <- df_sdg_reporting %>%
  inner_join(df_code_names)
rm(df_code_names)

# 
# df_sdg_reporting %>% 
#   filter(GeoAreaCode %in% df_code_region$GeoAreaCode) %>% 
#   select(GeoAreaCode, GeoAreaName) %>% 
#   unique %>% 
#   as.data.frame
# 
# df_sdg_reporting %>% 
#   filter(!GeoAreaCode %in% df_code_region$GeoAreaCode) %>% 
#   select(GeoAreaCode, ISOalpha3) %>% 
#   unique %>% 
#   as.data.frame

df_sdg_reporting <- df_sdg_reporting %>% 
  mutate(Type = ifelse(GeoAreaCode %in% df_code_region$GeoAreaCode, 
                       "Region", 
                       "Country"))

rm(df_code_region)

# additional columns to be added
df_info <- read_xlsx("Document/Info_of_series.xlsx")
df_sdg_reporting <- df_sdg_reporting %>% 
  left_join(df_info) %>% 
  select(-indicator)


df_sdg_reporting <- df_sdg_reporting %>% 
  arrange(SeriesID, desc(Time_Detail), desc(Type), GeoAreaCode) 

vec_var_ordered <- read_lines("Data/Auxiliary/Variable Order for Output.txt")  

df_sdg_reporting <- df_sdg_reporting %>% 
  select(all_of(vec_var_ordered))

saveRDS(df_sdg_reporting, file = "Data/2023/12.1 sdg reporting file except value column.RDS")

# final format change for df_sdg_reporting
df_sdg_reporting <- df_sdg_reporting %>% 
  mutate(Value = as.character(Value), 
         Value = ifelse(is.na(Value), "NaN", Value))

df_info <- df_info %>% 
  mutate(output_file_name = paste(116,
                                  Indicator, 
                                  SeriesID,
                                  SeriesCode
                                  ,sep = "-"
                                  # ,collapse = "-"
                                  ))
# i = 1

vec_source_files <- list.files("Document/DataRequestDocs_116/1. Package for Global reporting/ExcelTemplates_116", full.names = T)

df_summary_key_regions <- read_csv("Data/Auxiliary/Regional_grouping_storyline_order fixed.csv")

for (i in 1:nrow(df_info)) {
  df_output <- df_sdg_reporting %>% 
    filter(SeriesID == df_info$SeriesID[i])
  output_file_name <- df_info$output_file_name[i]
  
  source_file_name <- str_detect(pattern = output_file_name, 
                           string = vec_source_files) %>% 
    which
  source_file_name <- vec_source_files[source_file_name]
  
  output_file_name <- paste(output_file_name,
                            nrow(df_output), 
                            sep = "-")
  output_file_name <- paste0(output_file_name, ".xlsx")
  print(output_file_name)
  output_file_name <- paste0("Output/2023/", output_file_name)
  
  wb <- loadWorkbook(file = source_file_name)
  writeData(wb, x = df_output, sheet = "Data",rowNames = F, colNames = T,startRow = 1, startCol = 1)
  
  saveWorkbook(wb, file = output_file_name, overwrite = T)
  # openxlsx::write.xlsx(wb, 
  #                      file = source_file_name)
  
  df_output %>% 
    filter(Time_Detail == max(Time_Detail)) %>% 
    select(GeoAreaCode, Value) %>% 
    right_join(df_summary_key_regions) %>% 
    unique %>% 
    arrange(Order) %>% 
    print
  print(output_file_name)
  
}



