
# vec_files <- list.files("code/2023/")
# 
# vec_files <- vec_files[str_detect(vec_files, pattern = "0")] 
# 
# vec_files <- vec_files[order(vec_files)]
rm(list = ls())
source("code/2023/02. numerise data.R")
source("code/2023/03. adding country names and codes.R")
source("code/2023/04.1 use previous year's reporting.R")
source("code/2023/04.3 ext using CTGAP 2022.R")
source("code/2023/04.4 ext using NSDS status table.R")
source("code/2023/05. ext the survey data.R")
source("code/2023/06.1 fix multiple recipient issues in 17.19.1.R")
source("code/2023/06.2 combine all fixed region results together.R")
source("code/2023/07. create data for indicator 17.19.1.R")
source("code/2023/08. link old data with new data for 17.18.R")
source("code/2023/09. create data for 17.18.R")



# for (i in vec_files) {
#   path_file = paste0("code/2023/", i)
#   source(path_file)
#   print(i)
# }
# 
df_sdg %>% 
  ungroup() %>% 
  select(indicator, value = value_final) %>% 
  mutate(count = 1) %>% 
  pivot_wider(names_from = "indicator", 
              values_from = "count", 
              values_fn = sum) %>% 
  filter(!is.na(value)) %>% 
  # print %>%
  arrange(value)


df_sdg %>% 
  ungroup() %>% 
  select(indicator, value_2023) %>% 
  mutate(count = 1) %>% 
  pivot_wider(names_from = "indicator", 
              values_from = "count", 
              values_fn = sum) %>% 
  filter(!is.na(value_2023)) %>% 
  # print %>% 
  arrange(value_2023)



df_sdg %>% 
  ungroup() %>% 
  select(indicator, value = value_2022) %>% 
  mutate(count = 1) %>% 
  pivot_wider(names_from = "indicator", 
              values_from = "count", 
              values_fn = sum) %>% 
  filter(!is.na(value) )%>% 
  # print %>% 
  arrange(value)
