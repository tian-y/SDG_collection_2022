################################################################################
#
# Extract data from CTGAP survey
# Author: Johannes Abele
# Date: 03/03/2022
# 
# Objective: Exract information from 18 questions from Pillar 1 Area 1 and from 
#            2 questions from Pillar 1 Area 2
# 
# input file: - data/CTGAP_survey/ORGANISATION.tab
#             - data/CTGAP_survey/LINKS.tab
# 
# output file: - output/ORGANIZATION.xlsx
#
################################################################################


#-------------------------- Preparation ----------------------------------------

# Clear environment
if(!exists("save_as_excel")) {remove(list = ls()); save_as_excel = T}

# Load required libraries
packages <-
  c(
    "tidyverse",
    "readxl",
    "openxlsx",
    "httr"
    )
# Install uninstalled packages
lapply(packages[!(packages %in% installed.packages())], install.packages)
lapply(packages, library, character.only = TRUE)
rm(packages)

# Set wd
setwd(getwd())



#--------------------------- Load Data -----------------------------------------

# Define file name and path for ORGANIZATION.tab
file_name <- "ORGANIZATION.tab"
folder <- "CTGAP_survey"
file_path <- paste(getwd(), "data", folder, file_name, sep = "/")

# Load file
df_organization <- read_tsv(file_path)

# Extract relevant columns 
df_organization <- df_organization %>%
  select(interview__key,
         countryCode3,
         "countryNameId",
         starts_with("planningInstruments"),
         "linkToPlan",
         "nsdsFrom",
         "nsdsTo",
         "nsdsFromYear",
         "nsdsToYear",
         "nsdsNextYear",
         "nextPlan",
         "nextPlanWhen",
         "previousNSDS",
         "natDevPlan",
         "linkToPlan",
         "participatedPlanning",
         "coordWithin",
         "coordOutside",
         starts_with("activitiesOther"),
         "statsLawExists",
         starts_with("statsLawCovers")
         )

# Define file name and path for LINKS.tab
file_name <- "LINKS.tab"
file_path <- paste(getwd(), "data", folder, file_name, sep = "/")

# Load file
df_links <- read_tsv(file_path)

# Select varibales
df_links <- df_links %>%
  mutate(LINKS__id = NULL) %>% # drop LINKS_id
  unique() %>%
  select(interview__key,
         otherInstrument,
         starts_with("LinkTo"))


#---------------------------- Data Cleaning ------------------------------------

# Replace all ##N/A##, -999999999 with NA 
df_organization <- df_organization %>%
  mutate_all(~ na_if(., "##N/A##")) %>%
  mutate_all(~ na_if(., -999999999))
df_links <- df_links %>%
  mutate_all(~ na_if(., "##N/A##")) %>%
  mutate_all(~ na_if(., -999999999)) %>%
  select(where(~!all(is.na(.x)))) # remove all columns that contain only NA

# Collect all supplementory links in Link_Supp that exhibit same interview_key
#df_links_tmp <- df_links %>%
#  group_by(interview__key) %>%
#  mutate(rn = paste0("LinkTo_Supp",row_number())) %>%
#  spread(rn, LinkTo__0)

# Merge two dataframes
df_links_long <- df_links %>%
  ungroup() %>%
  gather(link_type, link_value, -interview__key) %>%
  filter(!is.na(link_value)) %>%
  group_by(interview__key, link_type) %>%
  summarise(links = paste0(link_value, collapse = ";_;")) %>%
  arrange(interview__key, link_type)

df_links_long$links = str_split(string = df_links_long$links, patter = ";_;" )

df_links_merged = df_links_long %>%
  spread(link_type, links)

rm(df_links_long)

# is.character(df_links_long$link_type)

df_organization <- df_organization %>%
  left_join(df_links_merged, by = "interview__key") 



#---------------------------- Save File ----------------------------------------

# Write as excel file
if(save_as_excel) {
  xlsx_sheet <- list("ORGANIZATION" = df_organization)
  file_name <- "ORGANIZATION.xlsx"
  write.xlsx(xlsx_sheet, paste(getwd(), "output", file_name, sep = "/"), overwrite = TRUE)
}

















