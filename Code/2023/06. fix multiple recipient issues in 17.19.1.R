rm(list = ls())
gc()
# df_press <- readRDS("~/dropbox/PARIS21/R/PRESS/Data/Intermediate/final_PRESS_2022.rds")
# 1. load original data from PRESS
df_press <- readRDS("~/dropbox/PARIS21/R/PRESS/Output/CH/data2022_final_toUpload_2022-10-27.rds")

## select necessary columns
df_sdg <- df_press %>% 
  select(ListRecip, reportedyear, usd_disbursement_defl, RecipientCode) 
rm(df_press)

# 2. select all the recipients
df_recipients <- df_sdg %>% 
  select(ListRecip, RecipientCode) %>% 
  unique

df_recipients <- df_recipients %>% 
  rename(rec = ListRecip, iso = RecipientCode) 

## 2.1 examine duplication problems
# df_recipients %>% select(ListRecip) %>% duplicated() %>% which
# df_recipients[237,]
# df_recipients %>% filter(ListRecip == "Kosovo")

## 2.2 fix duplication problems
df_recipients <- df_recipients %>% 
  mutate(iso = ifelse(rec == "Kosovo", "XKX", iso))
df_recipients <- df_recipients %>% 
  unique %>% 
  filter(!is.na(rec))
### save a copy of the recipient list
df_recipients_full <- df_recipients

## 2.3 filter out recipients without a code
df_recipients_without_iso <- df_recipients_full %>% 
  filter(is.na(iso)) 

## 2.4 for the ones that mentioned "specified" or "un allocated" or "regional", we assign a merker for special treatment
df_recipients_without_iso <- df_recipients_without_iso %>% 
  mutate(regional = str_detect(pattern = "regional", string = tolower(rec))) %>% 
  mutate(unspecified = str_detect(pattern = "specified|unallo", string = tolower(rec)))

df_recipients_regional <- df_recipients_without_iso  %>% 
  filter(regional|unspecified)

write_csv(df_recipients_regional, file = "data/2023/temp_regional.csv")
### work in excel sheet
df_recipients_regional_fixed <- read_csv("data/2023/temp_regional_fixed.csv")

  
## 2.5 for the rest, we will need to split them by commas
df_recipients_without_iso_non_regional <- df_recipients_without_iso %>% 
  filter(!regional, !unspecified)


## 2.6 split the comma-separated ones  
vec_recipients <- df_recipients_without_iso_non_regional %>% 
  .$rec

list_recipients <- vec_recipients %>% 
  lapply(FUN = str_split, pattern = ",\\s*") 

vec_rec_all <- list_recipients %>% unlist %>% unique
vec_rec_num <- sapply(list_recipients, FUN = function(x) length(unlist(x)))
vec_rec_num_4df <- rep(c(1:length(list_recipients)), vec_rec_num)
vec_rec_all_4df <- unlist(list_recipients)
df_rec_split <- tibble(rec_split = vec_rec_all_4df, num = vec_rec_num_4df )
rm(#vec_rec_all, 
   vec_rec_all_4df, 
   vec_rec_num, 
   vec_rec_num_4df, 
   vec_recipients, 
   list_recipients)

## 2.7 after split, find iso code for the singled out ones 
df_rec_all <- tibble(rec = vec_rec_all) %>%  
  mutate(iso = countrycode(vec_rec_all, "country.name", "iso3c")) %>% 
  mutate(m49 = countrycode(iso, "iso3c", "iso3n"))


## 2.8 for ones still without an iso, try to fix it
vec_rec_no_iso <- df_rec_all %>% 
  filter(is.na(iso)) %>% 
  .$rec

vec_rec_no_iso
df_rec_no_iso <- tibble(recipient_name = vec_rec_no_iso)
write_csv(df_rec_no_iso, file = "Data/2023/temp_rec_no_iso.csv")

### work off line
df_rec_no_iso_fixed <- read_csv("data/2023/temp_rec_no_iso_fixed.csv")




df_recipients <- tibble(recipients = vec_recipients)

df_recipients <- df_recipients %>% 
  mutate(iso = countrycode(recipients, "country.name", "iso3c"))

df_recipients %>% 
  filter(is.na(iso)) %>% 
  select(recipients) %>% 
  unique %>% 
  nrow
