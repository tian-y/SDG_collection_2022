file_token_original = "tokens_161377.csv"
file_contact = "1.NSO SDG Contact Persons_as of 10.09.2021.xlsx"
sheetname_contact = "NSO SDG Contact Person Info."



token_original = read_csv("Data/tokens_161377.csv")
contact = read_xlsx("Data/1.NSO SDG Contact Persons_as of 10.09.2021.xlsx", sheet = sheetname_contact)
names(contact)

contact = contact %>%
  select(countryt = Country, firstname = `Contact Person's First Name`, 
         lastname = `Contact Person's Last Name`, 
         email = Email, additional = `Please enter any additional information you would like to provide / Additional NOTES (in italics)`)




  


extract_emails = function(x) {
  x = str_subset( x, pattern = "@")
  x = ifelse(length(x)==0,  NA, x)
  x = gsub('^\\.|\\.$', '', x) 
  x = gsub('^\\,|\\,$', '', x) 
  x = gsub('[(]|[)]', '',x )
  x = ifelse(length(x)>1, paste0(x, collapse = ";"), x)
  return(x)
}


isValidEmail <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x), ignore.case=TRUE)
}

# Valid adresses
isValidEmail("felix@nicebread.de")
isValidEmail("felix.123.honeyBunny@nicebread.lmu.de")
isValidEmail("felix@nicebread.de  ")
isValidEmail("    felix@nicebread.de")
isValidEmail("felix+batman@nicebread.de")
isValidEmail("felix@nicebread.office")

# invalid addresses
isValidEmail("felix@nicebread")  
isValidEmail("felix@nicebread@de")
isValidEmail("felixnicebread.de")
isValidEmail(contact$final_email[65])
contact$final_email[65]

cc = contact$additional %>% str_split(pattern = "[ ]")%>% 
  lapply(FUN =extract_emails) %>%
  unlist

cc[!is.na(cc)] 

contact$cc = cc

contact = contact %>%
  mutate(cc = cc, 
         cc = ifelse(is.na(cc), "", cc)) %>%
  mutate(final_email = paste0(email,cc, sep = ";"))
head(contact$final_email)
contact$final_email

