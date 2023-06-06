rm(list = ls())

df_sdg_1718 <- readRDS("Data/2023/10. 17.18 filling missing values.RDS")
# df_sdg_1719 <- readRDS("Data/2023/10. 17.19 filling missing values.RDS")


df_sdg_1718 <- df_sdg_1718 %>% 
  mutate(country = countrycode(m49,"iso3n", "country.name"), 
         iso = countrycode(m49,"iso3n", "iso3c"))  %>% 
  # the south korea case
  mutate(total  = ifelse(iso == "KOR" & indicator =="nsds_funded",1, total )) %>% 
  # the kuwait case
  mutate(total = ifelse(iso == "KWT" & indicator =="statlaw",1, total ))

# the case for correcting using CTGAP data
df_sdg_1718 %>% 
  filter(indicator == "statlaw") %>% 
  filter(!is.na(iso)) %>% 
  group_by(country) %>% 
  mutate(sum = sum(total, na.rm = T)) %>% 
  filter(sum != 0, sum != 4) %>% 
  arrange(country, year)

df_sdg_1718 %>% 
  filter(indicator == "statlaw") %>% 
  filter(!is.na(iso)) %>% 
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
  mutate(`2022` = `2021`) %>% 
  gather(key = "year", value = "total_new", 
         -indicator, -iso, -country, -m49, -sum) %>% 
  mutate(year = as.numeric(year)) %>% 
  select(-sum)


df_sdg_1718_after_replace <- df_sdg_1718 %>% 
  left_join(df_sdg_1718_replace) %>% 
  mutate(total = ifelse(is.na(total_new), total, total_new)) %>% 
  select(-total_new)


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
rm(df_sdg_1718_after_replace, 
   df_sdg_1718_replace)

df_sdg_1718 <- df_sdg_1718 %>% 
  select(-country, -iso)


saveRDS(df_sdg_1718, file = "Data/2023/10.2 17.18 correcting errors.RDS")
  




