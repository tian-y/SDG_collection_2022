
# vec_files <- list.files("code/2023/")
# 
# vec_files <- vec_files[str_detect(vec_files, pattern = "0")] 
# 
# vec_files <- vec_files[order(vec_files)]
rm(list = ls())
# processing survey data
source("code/2023/02. numerise data.R")
source("code/2023/03. adding country names and codes_2024.R.R")

# solving issues in PRESS data for reporting
source("code/2023/06.1 fix multiple recipient issues in 17.19.1_2024.R.R")
source("code/2023/06.2 combine all fixed region results together_2024.R.R")
source("code/2023/07. create data for indicator 17.19.1.R")

# final cleaning and merge data for pulication
source("code/2023/08. link old data with new data for 17.18_2024.R.R")
source("code/2023/09. create data for 17.18.R")

source("code/2023/10.1 clean up and fill missing values with NA for all.R")
source("code/2023/10.3 regroup 17.18 after correcting errors_2024.R.R")

source("code/2023/11. merge to a single data file for reporting.R")

# prepare for reporting
source("code/2023/12.1 prepare names for codes.R")
