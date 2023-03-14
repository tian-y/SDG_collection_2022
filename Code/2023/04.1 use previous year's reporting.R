rm(list = ls())

df_sdg2022 <- readRDS("Code/SDG_reporting_working_2022/SDG_reporting_2021_new.rds")

df_sdg2022 <- df_sdg2022 %>% 
  filter(year == "2021") %>% 
  select(-year) # %>% 
  # spread(key = indicator, value = value)

df_sdg2022 %>% 
  select(indicator) %>% 
  table

df_indicator <- tibble(indicator = c("17.18.2", 
                                     "17.18.3_implement", 
                                     "17.18.3_funded"), 
                       indicator_2023 = c("statlaw", 
                                          "nsds_implement", 
                                          "nsds_funded"))

df_sdg2022 <- df_sdg2022 %>% 
  inner_join(df_indicator) %>% 
  mutate(indicator = indicator_2023) %>% 
  select(-indicator_2023)


df_sdg2022 <- df_sdg2022 %>% 
  spread(key = indicator, value = value) %>% 
  gather(key = indicator, value = value, -code) %>%
  rename(m49 = code)

rm(df_indicator)


df_sdg <- readRDS("data/2023/03. adding country names and codes.Rds")

# the different between collected data and previous year's data
df_sdg$nsds_funded %>% table
df_sdg2022 %>% filter(indicator == "nsds_funded") %>% select(value) %>% table

# see if the 2023 data is strictly a subset of 2022, if so, it means we basically didn't get any new information
vec_fullyfunded_2022 <- df_sdg2022 %>% filter(indicator == "nsds_funded", value == 1) %>% .$m49
vec_fullyfunded_2023 <- df_sdg %>% filter(nsds_funded == 1) %>% select(m49) %>% .$m49
vec_fullyfunded_2023 %in% vec_fullyfunded_2022
rm(vec_fullyfunded_2022, vec_fullyfunded_2023)

# change data to long format
df_sdg <- df_sdg %>% 
  gather(key = indicator, value = value, -token, -m49, -country, -iso)

# join 2022 data to 2023
df_sdg2022_updated <- df_sdg2022 %>% 
  rename(value_2022 = value) %>% 
  right_join(df_sdg) %>% 
  rename(value_2023 = value)

# fill data gaps in 2023 using 2022 data
df_sdg2022_updated <- df_sdg2022_updated %>% 
  mutate(value_final = ifelse(is.na(value_2023), value_2022, value_2023))

# quick tabulation
df_sdg2022_updated %>% filter(indicator == "nsds_funded") %>% select(value_final) %>% table
df_sdg2022_updated %>% filter(indicator == "nsds_implement") %>% select(value_final) %>% table

# see how many implemented ones are funded
df_sdg2022_updated %>% select(-value_2022, -value_2023) %>% spread(key = indicator, value = value_final) %>% select(m49, nsds_funded, nsds_implement) %>% filter(nsds_implement ==1) %>% select(nsds_funded) %>% table

# overall tabulation
df_sdg2022_updated %>% 
  group_by(indicator, value_final) %>% 
  summarise(total = n())

df_sdg2022_updated %>% 
  group_by(indicator, value_2022) %>% 
  summarise(total = n())


saveRDS(df_sdg2022_updated, file = "Data/2023/04.1 update use previous year's reporting.RDS")
