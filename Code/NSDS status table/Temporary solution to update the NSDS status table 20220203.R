rm(list = ls())
source("Code/SDG_reporting_working_2022/0. boot.R")

df_nsds <- read.csv("Data/Status_table_for_analysis.csv", 
                    encoding = "utf-8", stringsAsFactors = F)

df_nsds <- df_nsds %>% 
  mutate(iso = countrycode(Country, "country.name", "iso3c")) %>% 
  mutate(iso = ifelse(Country == "Kosovo", "XKX", iso))

df_ida <- read_csv("~/dropbox/PARIS21/R/PRESS/Data/Analysis/IDA status.csv")
df_ida <- df_ida %>% 
  select(iso = Code, ida = `2020`) %>%
  filter(ida == 1) 

df_nsds <- df_nsds %>% 
  left_join(df_ida) %>% 
  mutate(ida = ifelse(is.na(ida), 0, ida))

df_nsds <- df_nsds %>%
  mutate(Country = str_replace(Country, "[*]", "")) %>% 
  mutate(Country = ifelse(ida == 0, paste0(Country, "*"), Country))

df_nsds <- df_nsds %>% 
  mutate(summary1 = tolower(Status), 
         summary2 = tolower(Next.Plan)) %>% 
  mutate(summary = ifelse((summary1 == "expired" | summary1 == "no strategy" )& 
                            (summary2 == "not yet planned" | is.na(summary2)) , 
                          "expired no plan", NA)) %>% 
  mutate(summary = ifelse((summary1 == "expired" | summary1 == "no strategy" )& 
                            is.na(summary) , 
                          "expired with plan", summary)) %>% 
  mutate(summary = ifelse(is.na(summary), 
                          summary1, 
                          summary))


saveRDS(df_nsds, file = "Output/NSDS_Status_2023.RDS")

df_nsds %>% writexl::write_xlsx("Output/NSDS_Status_2023.xlsx")
