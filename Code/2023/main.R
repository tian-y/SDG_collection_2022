
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

source("code/2023/10.1 clean up and fill missing values with NA for all.R")

source("code/2023/10.2 correcting errors.R")
source("code/2023/10.3 regroup 17.18 after correcting errors.R")
source("code/2023/11. merge to a single data file for reporting.R")
source("code/2023/12.1 prepare names for codes.R")
