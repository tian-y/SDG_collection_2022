#-------------------------- Preparation ----------------------------------------

# Clear environment

# Load required libraries
packages <-
  c(
    "tidyverse",
    "readxl",
    "openxlsx",
    # "httr", 
    "countrycode", 
    "writexl"
  )
# Install uninstalled packages
lapply(packages[!(packages %in% installed.packages())], install.packages)
lapply(packages, library, character.only = TRUE)
rm(packages)

# Set wd
setwd(getwd())