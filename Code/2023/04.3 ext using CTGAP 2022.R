rm(list = ls())

df_ctgap <- read_tsv("~/dropbox/paris21/r/CH_data_processing_survey_2021/data/2212 CTGAP progress tracking/NSO.tab")
names(df_ctgap)
df_ctgap %>% 
  select(q39) %>% 
  table 
df_ctgap <- df_ctgap %>% 
  select(countryNameId, q39)

# clean country names in CTGAP survey
df_ctgap <- df_ctgap %>% 
  mutate(countryNameId = ifelse(countryNameId == "Азербайджан", "Azerbaijan", countryNameId)) %>% 
  mutate(countryNameId = ifelse(countryNameId == "Türkiye", "Turkey", countryNameId)) %>% 
  mutate(m49 = countrycode(countryNameId, "country.name", "iso3n"))

df_ctgap <- df_ctgap %>% 
  # select(m49, q39) %>% 
  mutate(q39_numerised = ifelse(q39 == 0, 1, ifelse(q39 == -999999999, NA, 0))) %>% 
  rename(country_ctgap = countryNameId)


# df_sdg <- readRDS("data/2023/03. adding country names and codes.Rds")

# df_ctgap <- df_ctgap %>% 
#   right_join(df_sdg)


# df_ctgap %>% 
#   filter(q39 == 0, nsds_funded != 1)

# df_ctgap %>% 
#   filter(q39 != 0,
#          q39 != -999999999, 
#          nsds_funded == 1)

# there are some countries whose reporting to SDG is different from the CTGAP survey on funding to NSDS/work programme
# for them we prioritise SDG

df_sdg_after4.1 <- readRDS("data/2023/04.1 update use previous year's reporting.RDS")


df_sdg_after4.1_ctgap <- df_sdg_after4.1 %>%
  # !!! very important step to remove the value in 2022 and 2023
  select(-value_2022, -value_2023) %>% 
  spread(key = indicator, value = value_final) %>% 
  # we also only try to fill the gaps for fully fundedness, therefore, we filter using nsds_implement
  filter(nsds_implement == 1 ) %>% 
  select(m49, nsds_funded) %>% 
  right_join(df_ctgap) 


df_sdg_after4.1_ctgap_long <- df_ctgap %>% 
  select(-q39) %>% 
  rename(value_ctgap = q39_numerised) %>% 
  mutate(indicator = "nsds_funded") %>% 
  right_join(df_sdg_after4.1)



# df_sdg_after4.1_ctgap <- df_sdg_after4.1_ctgap %>% 
#   mutate(nsds_funded_new_withCTGAP = ifelse(is.na(nsds_funded), q39_numerised, nsds_funded))

# 
# df_sdg_funded_update <- df_sdg_after4.1_ctgap %>%
#   mutate(nsds_funded_new = ifelse(is.na(nsds_funded), q39_numerised, nsds_funded))
# 
# df_sdg_funded_update %>% names
# 
# df_sdg_funded_update %>% 
#   select(nsds_funded, nsds_funded_new) %>% 
#   sapply(table)


saveRDS(df_sdg_after4.1_ctgap_long, file = "data/2023/04.3 ext using CTGAP 2022.RDS")
# the remaining question: what should be the priority between previous responses and the fully fundedness?
# did we include the previous CTGAP question on statistical planning, what should be the priority there?

