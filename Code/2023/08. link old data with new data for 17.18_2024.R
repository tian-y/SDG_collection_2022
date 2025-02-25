rm(list = ls())
gc()

df_region_code <- readRDS("Data/Auxiliary/region_code.RDS")

df_sdg_since2019 <- readRDS("data/2023/08. full 17.18 data without regional aggregation.RDS")

df_sdg <- readRDS("data/2024/05. ext the survey data_simpliefied.RDS")
df_sdg <- df_sdg %>% 
  inner_join(df_region_code) %>% 
  rename(value = value_final)

setdiff(names(df_sdg), names(df_sdg_since2019))
df_sdg_since2019 <- df_sdg %>% rbind(df_sdg_since2019)

saveRDS(df_sdg_since2019, file = paste0("data/",
                                        format(Sys.Date(), "%Y"), 
                                        "/08. full 17.18 data without regional aggregation.RDS"))

