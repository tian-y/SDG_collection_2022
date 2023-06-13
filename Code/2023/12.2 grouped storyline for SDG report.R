rm(list = ls())
df_sdg <- readRDS("Data/2023/12.1 sdg reporting file except value column.RDS")
df_region_names <- read_csv("Data/Auxiliary/Regional_grouping_storyline_order fixed.csv")
df_sdg_regions <- df_sdg %>% 
  inner_join(df_region_names) %>% 
  select(Time_Detail, Order, Value, GeoAreaName, Indicator, GeoAreaCode, SeriesID)


df_sdg_regions %>% 
  filter(Indicator == "17.19.1") %>% 
  filter(Time_Detail %in% c("2018","2020")) %>% 
  select(Time_Detail, GeoAreaName, Value, Order) %>%
  arrange(Order, Time_Detail) %>% 
  spread(key = Time_Detail, value = Value) %>% 
  arrange(desc(Order)) %>% 
  select(-Order) # %>% 
  # write_csv("output/2023/story_line_17.19.1_by_region.csv", na = "")

df_sdg_regions %>% 
  filter(Indicator == "17.19.1") %>% 
  filter(Time_Detail %in% c("2015","2018", "2020")) %>%
  # filter(Order %in% c(1, 10,11,12)) %>% 
  select(Time_Detail, GeoAreaName, Value, Order) %>%
  arrange(Order, Time_Detail) %>% 
  mutate(Value = Value/1000000) %>% 
  spread(key = Time_Detail, value = Value) %>% 
  arrange(desc(Order)) %>% 
  select(-Order) # %>% 
  # write_csv("output/2023/story_line_17.19.1_by_year.csv", na = "")


df_sdg %>% 
  select(SeriesDescription, SeriesID) %>% 
  unique

df_sdg %>% 
  filter(is.na(SeriesDescription))

df_sdg_regions %>% 
  filter(SeriesID == 1938) %>% 
  filter(Time_Detail %in% c("2019","2022")) %>%
  select(Time_Detail, GeoAreaName, Value, Order) %>%
  arrange(Order, Time_Detail) %>% 
  spread(key = Time_Detail, value = Value) %>% 
  arrange(desc(Order)) # %>% 
  # select(-Order) %>% 
  # write_csv("output/2023/story_line_17.19.1_by_region.csv", na = "")


df_sdg_regions %>% 
  filter(SeriesID == 1830) %>% 
  filter(Time_Detail %in% c("2019","2022")) %>%
  select(Time_Detail, GeoAreaName, Value, Order) %>%
  arrange(Order, Time_Detail) %>% 
  spread(key = Time_Detail, value = Value) %>% 
  arrange(desc(Order)) 

df_sdg_regions %>% 
  filter(SeriesID == 1938|SeriesID == 1830) %>% 
  filter(Time_Detail %in% c("2022")) %>%
  select(SeriesID, GeoAreaName, Value, Order) %>%
  arrange(Order, SeriesID) %>% 
  spread(key = SeriesID, value = Value) %>% 
  arrange(desc(Order)) 

