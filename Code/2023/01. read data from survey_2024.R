rm(list = ls())
source("code/SDG_reporting_working_2022/0. boot.R")
source("code/survey_911386_R_syntax_file.R")
# data_new <- data
# source("code/2023/survey_161377_R_syntax_file.R")

# names(data_new)
# names(data)

# a <- attributes(data_new)

# vec_att_new <- attributes(data_new)$names
# vec_att_old <- attributes(data)$names

# vec_att_new <- attributes(data_new)$variable.labels
# vec_att_old <- attributes(data)$variable.labels


# see how different is the two questions
# setdiff(vec_att_old, vec_att_new)
# intersect(vec_att_new, vec_att_old)

# data_old <- data %>% 
  # select(which(vec_att_old %in% vec_att_new))

# names(data_old) = attributes(data_old)$names
# names(data_new) = attributes(data_new)$names

# names(data_old) = attributes(data_old)$variable.labels
# names(data_new) = attributes(data_new)$variable.labels

# data <- rbind(data_old, data_new)

# data <- bind_rows(data_old, data_new)

df_completed <- data  %>%
  filter(!is.na(submitdate))

names(df_completed)
df_final_reporting <- df_completed %>% 
  select(Q1, 
         Q20, 
         Q2, 
         Q3:Q4_SQ004, 
         token) %>% 
  rename(statlaw = Q1, 
         nsds_exist = Q20, 
         nsds_implement = Q2, 
         nsds_funded = Q3, 
         nsds_gov = Q4_SQ001, 
         nsds_don = Q4_SQ002, 
         nsds_other = Q4_SQ003, 
         nsds_none = Q4_SQ004)

# attributes(df_final_reporting)$variable.labels <- attributes(data_new)$variable.labels[c(14:21, 6)] 

saveRDS(df_final_reporting, file = paste0("data/",
                                          year(Sys.Date()),
                                          "/01. data_for_reporting.RDS"))

