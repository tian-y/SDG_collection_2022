list_vars  = readLines("Code/SDG_reporting_working_2022/list_for_reporting.txt") 

list_vars = data.frame(name = list_vars, order = 1:length(list_vars), stringsAsFactors = F)

unique(df_for_annex_wide$name) %>% as.character()
a = unique(df_for_annex_wide$name) %>% as.character()
a[13] == list_vars$name[20]
list_vars$name[20] = a[13]
list_ins = unique(df_for_annex_wide$indicator) %>% as.character()
i = list_ins[1]
for (i in list_ins) {
  subset = df_for_annex_wide %>%
    filter(indicator == i) %>%
    select(-(`2014`:`2019`))
  subset = subset %>%
    right_join(list_vars) %>%
    arrange(order)
  df_name = paste0("indicator_", i)
  write.csv(subset, file = paste0(df_name, ".csv"))
  assign(df_name, subset)

}

subset = df_for_annex_wide %>%
  filter(indicator == "17.19.1") %>%
  select(-(`2014`:`2018`))
subset = subset %>%
  right_join(list_vars) %>%
  arrange(order)
df_name = paste0("indicator_", i)
write.csv(subset, file = paste0(df_name, ".csv"))
assign(df_name, subset)


list_ins = unique(df_sdg$indicator) %>% as.character()
i = list_ins[1]
# procude only 2021 results for the data annex
for (i in list_ins) {
  subset = df_sdg %>%
    filter(indicator == i) %>%
    filter(year == 2021)
  # subset = subset %>%
  #   right_join(list_vars) %>%
  #   arrange(order)
  df_name = paste0("indicator_", i)
  write.csv(subset, file = paste0(df_name, ".csv"))
  assign(df_name, subset)
}






