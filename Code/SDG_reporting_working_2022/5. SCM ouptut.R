source("Code/SDG_reporting/4. produce reporting.R")

df_sdg %>%names

df_scm = df_sdg %>% 
  filter(indicator %in% c("17.18.2", "17.18.3_implement", "17.18.3_funded")) %>%
  filter(year == 2021)%>%
  mutate(iso3c = countrycode(code, "iso3n", "iso3c")) %>%
  filter(!is.na(iso3c)) 
# channel islands are removed

df_scm_wide <- df_scm %>%
  select(-code)%>%
  spread(indicator, value)%>%
  rename(`135` = `17.18.2`, 
         `136` = `17.18.3_implement`, 
         `138` = `17.18.3_funded`) %>%
  mutate(`136` = ifelse(is.na(`136`)&!is.na(`138`),  1, `136`))

which(duplicated(df_scm_wide$iso3c))

write_csv(df_scm_wide, file = "Output/202204_SCM_SDG_indicators.csv")


colSums(df_scm_wide[,3:5], na.rm = T)
