source("YTreviewTemp/SDG_reporting/2.  generate annex and new data.R")

path_to_read = "YTreviewTemp/SDG_reporting/"
file_name = "press_2021.csv"
file_to_read = paste0(path_to_read, file_name)
df_press <- read.csv(file_to_read, encoding = "utf-8", stringsAsFactors = F)
df_press_processed <- df_press %>%
  filter(CommitmentDate >= 2014)%>%
  filter(CommitmentDate <= 2020) %>%
  mutate(CommitmentDate = ifelse(CommitmentDate>2019, 2019, CommitmentDate))  %>%
  filter(is.na(Ignore_in_reporting)| Ignore_in_reporting != 1) %>%
  filter(countrySpecific, 
         ListRecip != "Kosovo") %>%
  select(name = ListRecip,  year = CommitmentDate, value = usd_commitment_defl) %>%
  mutate(iso = countrycode(name, "country.name", "iso3n")) %>%
  select(-name) %>%
  group_by(iso,  year) %>%
  summarise(total = sum(value, na.rm = T)) %>%
  ungroup() 

df_press_processed_unspecific <- df_press %>%
  filter(CommitmentDate >= 2014) %>%
  filter(CommitmentDate <= 2020) %>%
  mutate(CommitmentDate = ifelse(CommitmentDate>2019, 2019, CommitmentDate))  %>%
  filter(is.na(Ignore_in_reporting)| Ignore_in_reporting != 1) %>%
  # filter(!countrySpecific, 
  #        ListRecip != "Kosovo") %>%
  select(#name = ListRecip,  
         year = CommitmentDate, value = usd_commitment_defl) %>%
  group_by(# name,
           year) %>%
  summarise(value= sum(value, na.rm = T)) %>%
  ungroup() %>%
  mutate(code = 1, indicator = "17.19.1")


df_17_19_2021 <- df_press_processed %>%
  filter(!is.na(iso)) %>%
  mutate(indicator = "17.19.1")  %>%
  rename(value = total, code = iso)
rm(df_press_processed)

# a = df_17_19_2021 %>%
#   spread(year, value)

df_history_to_2021_withpress <- df_history_to_2021 %>%
  filter(indicator != "17.19.1") %>%
  rbind(df_17_19_2021, df_press_processed_unspecific)
# df_history_to_2021_qatar <- df_history_to_2021_withpress %>%
#   filter(code == 634) %>%
#   filter(grepl(pattern = "17.18.3", x = indicator))
# 
# rm(df_history_to_2021_qatar)

# df_history_to_2021_withpress <- df_history_to_2021_withpress %>%
#   rm(indicator == "17.18.3_government_new")

df_final_submission <-  df_history_to_2021_withpress 

file_name = "SDG_reporting_2021.rds"

saveRDS(df_final_submission , file = paste0(path_to_read, file_name) )
