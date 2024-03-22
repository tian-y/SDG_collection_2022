rm(list = ls())


df_sdg <- readRDS(file = paste0("Data/", 
                                format(Sys.Date(), "%Y"), 
                                "/01. data_for_reporting.RDS")
                  )
names(df_sdg)

df_sdg %>% 
  select(1:8) %>% 
  sapply( table)



df_statlaw <- tibble(statlaw_value = c(1, 0, 0), 
                     statlaw = c("Yes, it complies with all principles", 
                                 "No, it doesn't exist or doesn't comply with any of the principles", 
                                 "No, it only complies with some principles")
                     )

df_sdg <- df_sdg %>% 
  left_join(df_statlaw) %>% 
  mutate(statlaw = statlaw_value) %>% 
  select(-statlaw_value) 
  
rm(df_statlaw)

df_sdg <- df_sdg %>% 
  mutate(across(nsds_exist:nsds_none, ~ as.numeric(.x == "Yes"))) 

df_sdg <- df_sdg %>% 
  mutate(across(nsds_gov:nsds_other, ~ ifelse(.x == 0, NA, .x)))

df_sdg <- df_sdg %>% 
  mutate(across(nsds_gov:nsds_other, ~ ifelse(nsds_none ==1, 0, .x)))


df_sdg %>% 
  select(1:8) %>% 
  sapply( table)


saveRDS(df_sdg, file = paste0("Data/", 
                              format(Sys.Date(), "%Y"), 
                              "/02. numerise data.RDS"), )
  
