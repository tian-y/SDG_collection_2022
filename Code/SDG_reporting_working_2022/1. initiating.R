rm(list = ls())


load("output/ORGANIZATION.rds")
names(df_organization)

df_organization = df_organization %>%
  select(interview__key:planningInstruments__12, 
         nsdsFrom:nsdsToYear, 
         statsLawCovers__102)


df_planningInstruments = df_organization %>%
  select(interview__key, planningInstruments__11:planningInstruments__12) %>%
  gather(key = planningInstruments , value = response, -interview__key) 
  
df_planningInstruments$planningInstruments = regmatches(df_planningInstruments$planningInstruments, 
           gregexpr("[[:digit:]]+", df_planningInstruments$planningInstruments)) %>% 
  unlist


df_nsds_or_nat_plan = df_planningInstruments %>%
  group_by(interview__key) %>%
  summarise(plan = max(response, na.rm = T))%>%
  # Warning message:
  # In max(response, na.rm = T) :
  # no non-missing arguments to max; returning -Inf
  # it means that some groups only have NAs
  mutate(plan = ifelse(plan %in% c(0,1), plan, NA))
  

# df_nsds_or_nat_plan =df_nsds_or_nat_plan %>%
#   mutate(plan = ifelse(plan ==1 , 
#                        "Yes",
#                        ifelse(plan == 0, 
#                               "No", 
#                               "Information unavailable")))
rm(df_planningInstruments)
df_stats_law = df_organization %>% 
  select(interview__key, statlaw = statsLawCovers__102) 

df_sdg = inner_join(df_nsds_or_nat_plan, df_stats_law)  %>%
  rename(key = interview__key)

df_sdg = df_organization %>%
  select(key = interview__key, iso = countryCode3) %>%
  inner_join(df_sdg)


save(df_sdg, file = "YTreviewTemp/SDG_reporting/sdg_statslaw_statsplanImplementation.rds")

rm(list = ls())


