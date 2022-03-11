rm(list = ls())
file_token_original = "tokens_161377.csv"
file_contact = "1.NSO SDG Contact Persons_as of 10.09.2021.xlsx"
sheetname_contact = "NSO SDG Contact Person Info."



token_original = read_csv("Data/tokens_161377.csv")
contact = read_xlsx("Data/1.NSO SDG Contact Persons_as of 10.09.2021.xlsx", sheet = sheetname_contact)
names(contact)

contact = contact %>%
  select(country = Country, firstname = `Contact Person's First Name`, 
         lastname = `Contact Person's Last Name`, 
         email = Email, additional = `Please enter any additional information you would like to provide / Additional NOTES (in italics)`, 
         is_sdg = `Is this person a contact person for all SDG related matters or for a specific SDG Goal or indicator only? (Please specify below)`, 
         pref = `Please indicate what types of communications the contact person prefers to be informed about. Check all that apply.`)


contact = contact %>%
  mutate(email =gsub(",rs", ".rs", email), 
         email = gsub(",com", ".com", email))

extract_emails = function(x) {
  x = str_subset( x, pattern = "@")
  x = ifelse(length(x)==0,  "", x)
  x = gsub('^\\.|\\.$', '', x) # some addresses are ended with a "."
  x = gsub('^\\,|\\,$', '', x) # some addresses are ended with a ","
  x = gsub('[(]|[)]', '',x ) # some addresses are in brackets
  x = ifelse(length(x)>1, paste0(x, collapse = ";"), x)
  return(x)
}

cc = contact$additional %>% str_split(pattern = "[ ]")%>% 
  lapply(FUN =extract_emails) %>%
  unlist
# cc[91]
# cc[!is.na(cc)] 

contact$cc = cc
rm(cc)
contact = contact %>%
  mutate(cc = cc) %>%
  mutate(final_email = str_c(email, cc, sep = ";"), 
         final_email = gsub(final_email, pattern = "[/]", replacement = ";"),
         final_email = gsub(final_email, pattern = "\n|\r", replacement =  ""),
         final_email = gsub(final_email, pattern = "[,]", replacement = ";") , 
         final_email = gsub(final_email, pattern = "[ ]", replacement = ""),
         final_email = gsub(final_email,pattern =  '^\\;|\\;$', replacement = ''), 
         final_email = gsub("[ ]", "", final_email)
         )

strangecharacter = substr(contact$final_email[202], 29, 29)
contact$final_email = gsub(pattern = strangecharacter, replacement = "", contact$final_email)

extract_email_from_angle_brackets = function(x) {
  x  = gsub("<|>", ";", x)
  x = str_split(x, pattern = ";")[[1]]
  x = unique(x)
  x = str_subset(x, pattern = "@")
  x = paste(x, collapse = ";")
}


contact$final_email = lapply(contact$final_email, extract_email_from_angle_brackets) %>% unlist


contact = contact %>%
  mutate(iso = countrycode(country, "country.name", "iso3c"))

contact %>% filter(grepl(x = pref, pattern = "data request", ignore.case = T)) %>% .$iso %>% unique %>% length()


dup_iso = contact$iso[duplicated(contact$iso)] %>% unique


contact_unique = contact %>%
  filter(!iso %in% dup_iso)

contact_dup = contact %>%
  filter(iso %in% dup_iso)




contact_to_merge = contact %>%
  select(firstname, lastname, email = final_email)


token_updated = full_join(contact_to_merge, token_original) %>%
  select(contains(names(token_original))) %>%
  filter(firstname != "Rajiv")

write_csv(token_updated, append = F , file = "Output/tokens_161377_new.csv", 
          na = "")




