rm(list = ls())

df_sdg_1718 <- readRDS(file = "Data/2023/10.2 17.18 correcting errors.RDS")
df_sdg_1719 <- readRDS(file = "Data/2023/10. 17.19 filling missing values.RDS")
df_sdg <- rbind(df_sdg_1718, df_sdg_1719)

df_sdg %>% 
  saveRDS("data/2023/10 all SDG ready to be reported in the simplest format.RDS")


# df_sdg <- df_sdg %>% 
#   mutate(country = countrycode(m49,"iso3n", "country.name"), 
#          iso = countrycode(m49,"iso3n", "iso3c")) 

# df_sdg %>%   
#   filter(year == 2021) %>% 
#   filter(indicator != "17.19.1") %>% 
#   filter(total < 2) %>%
#   select(indicator, total) %>% 
#   table

