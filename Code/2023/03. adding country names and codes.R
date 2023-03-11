
rm(list = ls())


# token_path <- "https://github.com/PARIS21-DATA/Email_automation_tool/blob/94fbbefb239700c2734d91208595e7d73a40a054/SDG_reporting/tokens.csv"
token_path <- "~/dropbox/paris21/R/Email_automation_tool/SDG_reporting/tokens.csv"
df_token <- read.csv(token_path)
rm(token_path)
df_sdg <- readRDS("data/2023/02. numerise data.RDS")
# df_regions <- load("code/SDG_reporting_working_2022/2021/regional grouping.RData")

df_token <- df_token %>% 
  select(token, M49Code, countryname, ISOCode) %>% 
  rename(m49 = M49Code, 
         country = countryname, 
         iso = ISOCode)



df_sdg <- df_sdg %>%
  inner_join(df_token)

saveRDS(df_sdg, file = "data/2023/03. adding country names and codes.Rds")