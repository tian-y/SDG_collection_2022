

df_regions <- readRDS("Data/Auxiliary/region_code.RDS") 
df_regions <- df_regions %>% 
  filter(region_type %in% c("sdg_region", "ldc", "lldc")) %>% 
  select(region_code) %>% 
  unique
vec_regions <- c(df_regions$region_code, 1)
rm(df_regions)

df_region_names <- readRDS("Data/Auxiliary/m49 code and names.RDS")
df_region_names <- df_region_names %>% 
  filter(GeoAreaCode %in% vec_regions) %>% 
  select(-ISOalpha3) 
df_region_names %>%
  write_csv("data/Auxiliary/Regional_grouping_storyline_order.csv")
rm(vec_regions)


