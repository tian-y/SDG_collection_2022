df_m49_all <- df_sdg %>% 
  select(m49) %>% 
  unique

df_m49_all %>%
  filter(!m49 %in% df_code_names$GeoAreaCode) %>%
  mutate(country = countrycode(m49,"iso3n","country.name"))

df_m49_all %>%
  filter(!m49 %in% df_code_names$GeoAreaCode) %>%
  inner_join(df_sdg) %>%
  filter(!is.na(total)) %>%
  select(m49) %>%
  unique

df_m49_all %>% 
  filter(!m49 %in% df_code_names$GeoAreaCode) %>% 
  filter(!m49 %in% df_code_MDG_only$GeoAreaCode)
rm(df_m49_all)