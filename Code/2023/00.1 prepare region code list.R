rm(list = ls())
gc()

df_code <- read_csv("data/Auxiliary/m49code.csv")
df_code <- df_code %>% 
  select(m49, 
         iso, 
         sdg_region,
         m49_level1_region, 
         m49_level2_region, 
         mdg, 
         ldc, 
         lldc
         )

df_code_long <- df_code %>% 
  gather(key = "region_type", value = "regioncode", 
         -m49, -iso) %>% 
  filter(!is.na(regioncode))

saveRDS(df_code_long, file = "data/Auxiliary/region_code.RDS")
