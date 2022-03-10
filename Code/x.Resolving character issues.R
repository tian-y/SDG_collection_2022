gsub("emmanuelfrancis26@yahoo.fr;francagbeti26@gmail,com", pattern = "[/]", replacement = ";")
contact %>%
  slice(294) %>%
  select(email,cc, final_email)
head(contact$final_email)
a = contact$final_email %>% str_split(";") %>%
  lapply(FUN = function(x) x[x!=""]  ) 

a %>%
  lapply(FUN = function(x) length(x) == sum(grepl(x = x,pattern =  "@"))   ) %>%
  unlist %>%
  sum

isValidEmail <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x), ignore.case=TRUE)
}

{# Valid adresses
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
  contact$final_email[65]}