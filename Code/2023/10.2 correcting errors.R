rm(list = ls())
source("code/boot.R")

df_sdg_1718 <- readRDS("Data/2023/10. 17.18 filling missing values.RDS")
# df_sdg_1719 <- readRDS("Data/2023/10. 17.19 filling missing values.RDS")


df_sdg_1718 <- df_sdg_1718 %>% 
  mutate(country = countrycode(m49,"iso3n", "country.name"), 
         iso = countrycode(m49,"iso3n", "iso3c"))  %>% 
  mutate(iso = ifelse(is.na(iso), "NULL",iso)) %>% 
  # the south korea case
  mutate(total  = ifelse(iso == "KOR" & indicator =="nsds_funded" & year != 2022,NA, total )) %>% 
  mutate(total  = ifelse(iso == "KOR" & year == 2022 & indicator!= "nsds_implement", NA , total )) %>% 
  mutate(total  = ifelse(iso == "KOR" & year == 2022 & indicator== "statlaw", 1 , total )) %>% 
  mutate(total  = ifelse(iso == "KOR" & year == 2022 & indicator== "nsds_funded", 1 , total )) %>% 
  mutate(total  = ifelse(iso == "ATG" & year > 2019 & indicator== "nsds_funded", NA , total )) %>% 
  mutate(total  = ifelse(iso == "LUX" & indicator== "nsds_funded", NA , total )) %>% 
  mutate(total  = ifelse((iso %in% c("ARG", "BRN") ) 
                         & !is.na(iso) 
                         & indicator == "nsds_implement"
                         & year == 2019, 
                         1 , total )) %>% 
  mutate(total  = ifelse(iso == "ECU" & indicator== "nsds_implement" & year ==2020, 1 , total )) %>% 
  mutate(total  = ifelse((iso == "PLW" ) 
                         # & !is.na(iso) 
                         & indicator %in% c("nsds_implement", "nsds_funded")
                         & !is.na(indicator)
                         & year == 2019, 
                         0 , total )) %>% 
  # the kuwait case
  mutate(total = ifelse(iso == "KWT" & indicator =="statlaw",1, total )) 

# the case for correcting using CTGAP data
df_sdg_1718 %>% 
  filter(indicator == "statlaw") %>% 
  filter(!is.na(iso)) %>% 
  filter(iso != "NULL") %>% 
  group_by(country) %>% 
  mutate(sum = sum(total, na.rm = T)) %>% 
  filter(sum != 0, sum != 4) %>% 
  arrange(country, year)

df_sdg_1718 %>% 
  filter(indicator == "statlaw") %>% 
  filter(!is.na(iso)) %>% 
  filter(iso != "NULL") %>% 
  group_by(country) %>% 
  mutate(sum = sum(total, na.rm = T)) %>% 
  filter(sum != 0, sum != 4) %>% 
  arrange(country, year) %>% 
  ungroup %>% 
  spread(key = year, value = total) %>% 
  filter(`2021`!= `2020`) %>% 
  filter(`2020`==`2022` | `2022`  ==0) 



df_sdg_1718 %>% 
  filter(indicator == "statlaw") %>% 
  filter(!is.na(iso)) %>% 
  filter(iso != "NULL") %>% 
  group_by(country) %>% 
  mutate(sum = sum(total, na.rm = T)) %>% 
  filter(sum != 0, sum != 4) %>% 
  arrange(country, year) %>% 
  ungroup %>% 
  spread(key = year, value = total) %>% 
  filter(`2021`!= `2020`) %>% 
  filter(`2020`==`2022` | `2022`  ==0) %>% 
  # mutate(`2021` = ifelse(iso %in% c("GRD","CIV", "MDG"), NA, `2021`)) %>%
  mutate(`2021` = `2020`) %>% 
  mutate(`2021` = ifelse(iso == "GRD", NA, `2021`)) %>%
  mutate(`2022` = ifelse(iso == "GRD", NA, `2022`)) %>%
  mutate(`2021` = ifelse(iso == "CIV", NA, `2021`)) %>%
  mutate(`2022` = ifelse(iso == "CIV", NA, `2022`)) %>%
  mutate(`2021` = ifelse(iso == "MDG", NA, `2021`)) %>%
  mutate(`2022` = ifelse(iso == "MDG", NA, `2022`)) %>%
  mutate(`2021` = ifelse(iso == "SLE", 0, `2021`)) %>% 
  mutate(`2021` = ifelse(iso %in% c("ALB", "BIH", "BLR", "SUR", "MYS"), 
                         NA, `2021`))
  # mutate(`2022` = `2021`) 


df_sdg_1718_replace <- df_sdg_1718 %>% 
  filter(indicator == "statlaw") %>% 
  filter(!is.na(iso)) %>% 
  group_by(country) %>% 
  mutate(sum = sum(total, na.rm = T)) %>% 
  filter(sum != 0, sum != 4) %>% 
  arrange(country, year) %>% 
  ungroup %>% 
  spread(key = year, value = total) %>% 
  filter(`2021`!= `2020`) %>% 
  filter(`2020`==`2022` | `2022`  ==0) %>% 
  mutate(`2021` = `2020`) %>% 
  mutate(`2021` = ifelse(iso == "GRD", NA, `2021`)) %>%
  mutate(`2022` = ifelse(iso == "GRD", NA, `2022`)) %>%
  mutate(`2021` = ifelse(iso == "CIV", NA, `2021`)) %>%
  mutate(`2022` = ifelse(iso == "CIV", NA, `2022`)) %>%
  mutate(`2021` = ifelse(iso == "MDG", NA, `2021`)) %>%
  mutate(`2022` = ifelse(iso == "MDG", NA, `2022`)) %>%
  mutate(`2021` = ifelse(iso == "SLE", 0, `2021`))  %>% 
  mutate(`2021` = ifelse(iso %in% c("ALB", "BIH", "BLR", "SUR", "MYS"), 
                         NA, `2021`)) %>% 
  gather(key = "year", value = "total_new", 
         -indicator, -iso, -country, -m49, -sum) %>% 
  mutate(year = as.numeric(year)) %>% 
  select(-sum) %>% 
  mutate(to_replace = T)


df_sdg_1718_after_replace <- df_sdg_1718 %>% 
  left_join(df_sdg_1718_replace) %>% 
  mutate(total = ifelse(is.na(to_replace), total, total_new)) %>% 
  select(-total_new, -to_replace)


df_sdg_1718_after_replace %>% 
  filter(indicator == "statlaw") %>% 
  filter(!is.na(iso)) %>% 
  group_by(country) %>% 
  mutate(sum = sum(total, na.rm = T)) %>% 
  filter(sum != 0, sum != 4) %>% 
  arrange(country, year) %>% 
  ungroup %>% 
  spread(key = year, value = total) %>% 
  filter(`2021`!= `2020`) %>% 
  filter(`2020`==`2022` | `2022`  ==0) %>% 
  mutate(`2021` = `2020`) %>% 
  mutate(`2022` = `2021`) 





df_sdg_1718 <- df_sdg_1718_after_replace


df_sdg_1718 %>% 
  filter(indicator == "statlaw") %>% 
  filter(!is.na(iso)) %>% 
  filter(iso != "NULL") %>% 
  # group_by(country) %>% 
  # mutate(sum = sum(total, na.rm = T)) %>% 
  # filter(sum != 0, sum != 4) %>% 
  # arrange(country, year) %>% 
  # ungroup %>% 
  spread(key = year, value = total) %>% 
  filter(`2021`!= `2020`|(is.na(`2020`) & `2021` == 1))# %>% 
  # filter(`2020`==`2022` | `2022`  ==0) 


rm(df_sdg_1718_after_replace, 
   df_sdg_1718_replace)

df_sdg_1718 <- df_sdg_1718 %>% 
  select(-country, -iso)


saveRDS(df_sdg_1718, file = "Data/2023/10.2 17.18 correcting errors.RDS")
  




