rm(list = ls())

df_sdg <- readRDS("data/2023/03. adding country names and codes.Rds")

df_sdg <- df_sdg %>% 
  select(token, nsds_funded, nsds_gov:nsds_none) 

df_sdg %>% 
  filter(nsds_funded == 1) %>% 
  mutate(across(nsds_gov:nsds_none, ~ ifelse(is.na(.x), 3, .x))) %>% 
  select(nsds_gov:nsds_none) %>% 
  sapply(table)


# there seems to be very little point to do so. Given that all the countries responded to this question. Only one country contradicted itself. 
# we definitely don't do it to the previous years' responses given that we have little information 


