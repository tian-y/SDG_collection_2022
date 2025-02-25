
rm(list = ls())

# token_path <- "https://github.com/PARIS21-DATA/Email_automation_tool/blob/94fbbefb239700c2734d91208595e7d73a40a054/SDG_reporting/tokens.csv"
# token_path <- "~/dropbox/paris21/R/Email_automation_tool/SDG_reporting/tokens.csv"
token_path <- paste0("data/",
                     format(Sys.Date(), "%Y"),
                     "/tokens.csv")
df_token <- read.csv(token_path)
rm(token_path)
df_sdg <- readRDS(paste0("data/",
                         format(Sys.Date(), "%Y"),
                         "/02. numerise data.RDS"))
# df_regions <- load("code/SDG_reporting_working_2022/2021/regional grouping.RData")

df_token <- df_token %>% 
  select(token, M49Code, countryname, ISOCode) %>% 
  rename(m49 = M49Code, 
         country = countryname, 
         iso = ISOCode) 

df_token <- df_token %>% 
  filter(iso!= "P21")

# df_token %>% 
#   filter(!is.na(iso)) %>% 
#   mutate(iso3n = countrycode(iso, "iso3c", "iso3n")) %>% 
#   filter(m49!=iso3n)

df_sdg <- df_sdg %>%
  right_join(df_token)

df_sdg <- df_sdg %>% 
  gather(key = "indicator", value = "value_final"
         , -m49, -country, -iso, -token) %>% 
  select(-token, -country, -iso)

df_17.18 <- readRDS("data/auxiliary/indicators17.18_full.rds")
df_sdg <- df_sdg %>% 
  right_join(df_17.18) %>% 
  mutate(year = 2023)


saveRDS(df_sdg, file = paste0("data/",
                              format(Sys.Date(), "%Y"),
                              "/05. ext the survey data_simpliefied.RDS"))
