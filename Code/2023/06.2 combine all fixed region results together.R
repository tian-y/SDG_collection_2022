rm(list = ls())
gc()
load("data/2023/06. intermediate fixing multi recipient issues.Rdata")
df_region_code <- readRDS("data/Auxiliary/region_code.RDS")

# 1. split out the recipients with iso and add m49 code
df_recipients <- df_recipients %>% 
  mutate(m49 = countrycode(iso, "iso3c", "iso3n")) 

df_recipients_with_iso <- df_recipients %>% 
  filter(!is.na(iso)) %>% 
  left_join(df_region_code)



# 2. work with the splited ones, you will need to summarise the underlying regions of the group of recipients
## 2.1 join the splited ones that has iso to region codes
df_rec_split_with_iso <- df_rec_all %>% 
  filter(!is.na(iso)) %>% 
  left_join(df_region_code)
rm(df_rec_all)

## 2.2 join the splited ones that has no iso to region codes
df_rec_no_iso_all_fixed <- df_rec_no_iso_all_fixed %>% 
  mutate(iso = NA, 
         m49 = NA) %>% 
  rename(rec = recipient_name)

## 2.3 combine the two, you get all the splited ones with region codes assigned
df_rec_wo_iso_all <- df_rec_split_with_iso %>% 
  rbind(df_rec_no_iso_all_fixed)

rm(df_rec_split_with_iso)  

## 2.4 now summarise the splitted ones
df_rec_split_region <- df_rec_split %>% 
  rename(rec = rec_split) %>% 
  left_join(df_rec_wo_iso_all) %>% 
  filter(!is.na(region_type)) %>% 
  select(num, region_type, region_code) %>% 
  unique %>% 
  # mutate(region_type = ifelse(is.na(region_type), "NA", region_type)) %>% 
  group_by(num, region_type) %>% 
  filter(n() == 1) 
rm(df_rec_wo_iso_all, 
   df_rec_split)
### !!! warning, this will also remove the ones with NA in their code

## 2.5 merge it with the original unsplited list
df_recipients_without_iso_non_regional_fixed <- df_recipients_without_iso_non_regional %>% 
  select(rec, num) %>% 
  # mutate(num = c(1:n())) %>% 
  left_join(df_rec_split_region) %>% 
  select(-num) 

df_recipients_without_iso_non_regional_fixed <- df_recipients_without_iso_non_regional_fixed %>% 
  mutate(m49 = NA, 
         iso = NA)


rm(df_rec_split_region)



# 3. assign region codes to the regional ones that were not splited
df_recipients_without_iso_fixed <- df_recipients_without_iso %>% 
  filter(regional|unspecified) %>% 
  select(rec) %>% 
  left_join(df_rec_no_iso_all_fixed) 
rm(df_rec_no_iso_all_fixed)

# 4. merge all the added 

df_recipients_fixed <- rbind(df_recipients_without_iso_fixed, 
      df_recipients_without_iso_non_regional_fixed) %>% 
  unique


df_recipients_regions <- df_recipients_fixed %>% 
  rbind(df_recipients_with_iso)


saveRDS(df_recipients_regions , "data/2023/06.2 Recipients and region codes.RDS")



