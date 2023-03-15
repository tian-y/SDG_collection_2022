rm(list = ls())
source("code/SDG_reporting_working_2022/0. boot.R")
# merge the NSDS status table to the results
df_sdg <- readRDS("Data/2023/04.3 ext using CTGAP 2022.RDS")
df_nsds <- readRDS("Output/NSDS_Status_2023.RDS")



df_nsds <- df_nsds %>% 
  select(country_nsds = Country, Status) %>% 
  mutate(m49 = countrycode(country_nsds, "country.name", "iso3n")) 

df_nsds %>% 
  select(Status) %>% 
  table
vec_status <- df_nsds %>% 
  .$Status %>% 
  unique

vec_status

df_status <- tibble(Status = vec_status, 
                    value = c(0, 1, 0, 0, 0, 0))

df_nsds <- df_nsds %>% 
  inner_join(df_status) %>% 
  filter(!is.na(m49)) %>% 
  mutate(indicator = "nsds_implement") %>% 
  select(-Status) %>% 
  rename(value_nsds_status_table = value)
rm(df_status)

df_sdg <- df_sdg %>% 
  left_join(df_nsds)

df_sdg %>% 
  filter(indicator =="nsds_implement") %>% 
  select(value_final) %>% 
  table

df_sdg %>% 
  filter(indicator =="nsds_implement") %>% 
  select(value_nsds_status_table) %>% 
  table

# df_sdg <- df_sdg %>% 
#   mutate(value_final_nsds_status = ifelse(is.na(value_final), value_nsds_status_table, value_final))


# df_sdg %>% 
#   filter(indicator =="nsds_implement") %>% 
#   select(value_final_nsds_status) %>% 
#   table


# df_sdg %>% 
#   filter(is.na(value_final), !is.na(value_final_nsds_status)) %>% 
#   select(m49, country)


df_sdg %>% 
  saveRDS("data/2023/04.4 adding nsds table for implementation status.RDS")

