rm(list = ls())

df_sdg_old <- readRDS(paste0("Data/", 
                             as.numeric(format(Sys.Date(), "%Y"))-1, 
                             # "/04.1 update use previous year's reporting.RDS"))
                             "/05. ext the survey data.RDS"))



df_sdg_old <- df_sdg_old %>% 
  rename(value = value_final) %>% 
  # filter(year == "2022") %>% 
  # select(-value_2022, - value_2023) # %>% 
  # spread(key = indicator, value = value)
  select(value, m49, indicator, token)

df_sdg_old %>% 
  select(indicator) %>% 
  table

df_indicator <- tibble(indicator = c("17.18.2", 
                                     "17.18.3_implement", 
                                     "17.18.3_funded"), 
                       indicator_2023 = c("statlaw", 
                                          "nsds_implement", 
                                          "nsds_funded"))

# df_sdg2022 <- df_sdg2022 %>% 
#   inner_join(df_indicator) %>% 
#   mutate(indicator = indicator_2023) %>% 
#   select(-indicator_2023)


# df_sdg2022 <- df_sdg2022 %>% 
#   spread(key = indicator, value = value) %>% 
#   gather(key = indicator, value = value, -m49) # %>%
  # rename(m49 = code)

rm(df_indicator)


df_sdg <- readRDS(paste0("Data/", 
                         format(Sys.Date(), "%Y"), 
                         "/03. adding country names and codes.Rds"))

# the different between collected data and previous year's data
df_sdg$nsds_funded %>% table
df_sdg_old %>% filter(indicator == "nsds_funded") %>% select(value) %>% table

# see if the 2023 data is strictly a subset of 2022, if so, it means we basically didn't get any new information
# vec_fullyfunded_2022 <- df_sdg2022 %>% filter(indicator == "nsds_funded", value == 1) %>% .$m49
# vec_fullyfunded_2023 <- df_sdg %>% filter(nsds_funded == 1) %>% select(m49) %>% .$m49
# vec_fullyfunded_2023 %in% vec_fullyfunded_2022
# rm(vec_fullyfunded_2022, vec_fullyfunded_2023)

# change data to long format
df_sdg <- df_sdg %>% 
  gather(key = indicator, value = value, -token, -m49, -country, -iso)
setdiff(names(df_sdg), 
        names(df_sdg_old))

# join 2022 data to 2023
df_sdg_old_updated <- df_sdg_old %>% 
  select(-token) %>% 
  rename(value_old = value) %>% 
  left_join(df_sdg) %>% 
  rename(value_new = value)

# fill data gaps in 2023 using 2022 data
df_sdg_old_updated <- df_sdg_old_updated %>% 
  mutate(value_final = ifelse(is.na(value_new), value_old, value_new))

# quick tabulation
df_sdg_old_updated %>% filter(indicator == "nsds_funded") %>% select(value_final) %>% table
df_sdg_old_updated %>% filter(indicator == "nsds_implement") %>% select(value_final) %>% table
df_sdg_old %>% filter(indicator == "nsds_implement") %>% select(value) %>% table

# see how many implemented ones are funded
df_sdg_old_updated %>% select(-value_old, -value_new) %>% spread(key = indicator, value = value_final) %>% select(m49, nsds_funded, nsds_implement) %>% filter(nsds_implement ==1) %>% select(nsds_funded) %>% table

# overall tabulation
df_sdg_old_updated %>% 
  group_by(indicator, value_final) %>% 
  summarise(total = n())

df_sdg_old_updated %>% 
  group_by(indicator, value_old) %>% 
  summarise(total = n())

df_sdg_old_updated %>% 
  group_by(indicator, value_new) %>% 
  summarise(total = n())


saveRDS(df_sdg_old_updated, file = paste0("Data/", 
                                          format(Sys.Date(), "%Y"), 
                                          "/04.1 update use previous year's reporting.RDS"))


saveRDS(df_sdg_old_updated, file = paste0("Data/", 
                                          format(Sys.Date(), "%Y"), 
                                          "/05. ext the survey data.RDS"))


df_sdg_reduced <- df_sdg_old_updated %>% 
  select(m49, indicator, value_final) %>% 
  unique %>% 
  mutate(year = 2023)

df_sdg_reduced %>% 
  saveRDS(file = paste0("Data/", 
                        format(Sys.Date(), "%Y"), 
                        "/05. ext the survey data_simpliefied.RDS"))
