data <- read.csv("survey_911386_R_data_file.csv", quote = "'\"", na.strings=c("", "\"\""), stringsAsFactors=FALSE, fileEncoding="UTF-8-BOM")


# LimeSurvey Field type: F
data[, 1] <- as.numeric(data[, 1])
attributes(data)$variable.labels[1] <- "id"
names(data)[1] <- "id"
# LimeSurvey Field type: DATETIME23.2
data[, 2] <- as.character(data[, 2])
attributes(data)$variable.labels[2] <- "submitdate"
names(data)[2] <- "submitdate"
# LimeSurvey Field type: F
data[, 3] <- as.numeric(data[, 3])
attributes(data)$variable.labels[3] <- "lastpage"
names(data)[3] <- "lastpage"
# LimeSurvey Field type: A
data[, 4] <- as.character(data[, 4])
attributes(data)$variable.labels[4] <- "startlanguage"
names(data)[4] <- "startlanguage"
# LimeSurvey Field type: A
data[, 5] <- as.character(data[, 5])
attributes(data)$variable.labels[5] <- "Seed"
names(data)[5] <- "q_"
# LimeSurvey Field type: A
data[, 6] <- as.character(data[, 6])
attributes(data)$variable.labels[6] <- "token"
names(data)[6] <- "token"
# LimeSurvey Field type: DATETIME23.2
data[, 7] <- as.character(data[, 7])
attributes(data)$variable.labels[7] <- "startdate"
names(data)[7] <- "startdate"
# LimeSurvey Field type: DATETIME23.2
data[, 8] <- as.character(data[, 8])
attributes(data)$variable.labels[8] <- "datestamp"
names(data)[8] <- "datestamp"
# LimeSurvey Field type: A
data[, 9] <- as.character(data[, 9])
attributes(data)$variable.labels[9] <- "[First name LAST NAME] Please provide your contact information so we can reach out to you for validation and update. "
names(data)[9] <- "O1_SQ002"
# LimeSurvey Field type: A
data[, 10] <- as.character(data[, 10])
attributes(data)$variable.labels[10] <- "[Position] Please provide your contact information so we can reach out to you for validation and update. "
names(data)[10] <- "O1_SQ003"
# LimeSurvey Field type: A
data[, 11] <- as.character(data[, 11])
attributes(data)$variable.labels[11] <- "[Institution] Please provide your contact information so we can reach out to you for validation and update. "
names(data)[11] <- "O1_SQ004"
# LimeSurvey Field type: A
data[, 12] <- as.character(data[, 12])
attributes(data)$variable.labels[12] <- "[Email address] Please provide your contact information so we can reach out to you for validation and update. "
names(data)[12] <- "O1_SQ005"
# LimeSurvey Field type: A
data[, 13] <- as.character(data[, 13])
attributes(data)$variable.labels[13] <- "Does the current national statistical legislation in your country comply with the 10 UN Fundamental Principles of Official Statistics (UNFPOS)? "
data[, 13] <- factor(data[, 13], levels=c("A1","A2","A3"),labels=c("Yes, it complies with all principles", "No, it doesn\'t exist or doesn\'t comply with any of the principles", "No, it only complies with some principles"))
names(data)[13] <- "Q1"
# LimeSurvey Field type: A
data[, 14] <- as.character(data[, 14])
attributes(data)$variable.labels[14] <- "Does your country have a statistical planning document (NSDS/ National Statistical Plan/ National Statistics Office Strategic Plan etc.)?"
data[, 14] <- factor(data[, 14], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[14] <- "Q20"
# LimeSurvey Field type: F
data[, 15] <- as.numeric(data[, 15])
attributes(data)$variable.labels[15] <- "The National Strategy for the Development of Statistics (NSDS)/National Statistical Plan/ National Statistics Office Strategic Plan was under implementation in 2023:"
data[, 15] <- factor(data[, 15], levels=c(1,2),labels=c("Yes", "No"))
names(data)[15] <- "Q2"
# LimeSurvey Field type: F
data[, 16] <- as.numeric(data[, 16])
attributes(data)$variable.labels[16] <- "The National Strategy for the Development of Statistics (NSDS)/National Statistical Plan/ National Statistics Office Strategic Plan was fully funded in 2023: "
data[, 16] <- factor(data[, 16], levels=c(1,2),labels=c("Yes", "No"))
names(data)[16] <- "Q3"
# LimeSurvey Field type: F
data[, 17] <- as.numeric(data[, 17])
attributes(data)$variable.labels[17] <- "[Government] Which of the following source(s) fully funded its share of the allocated budget for the national statistical plan in 2023?"
data[, 17] <- factor(data[, 17], levels=c(1,0),labels=c("Yes", "Not selected"))
names(data)[17] <- "Q4_SQ001"
# LimeSurvey Field type: F
data[, 18] <- as.numeric(data[, 18])
attributes(data)$variable.labels[18] <- "[Donor(s)] Which of the following source(s) fully funded its share of the allocated budget for the national statistical plan in 2023?"
data[, 18] <- factor(data[, 18], levels=c(1,0),labels=c("Yes", "Not selected"))
names(data)[18] <- "Q4_SQ002"
# LimeSurvey Field type: F
data[, 19] <- as.numeric(data[, 19])
attributes(data)$variable.labels[19] <- "[Other sources (private sector, academic institutions, non-profit organizations, research organizations, etc.)] Which of the following source(s) fully funded its share of the allocated budget for the national statistical plan in 2023?"
data[, 19] <- factor(data[, 19], levels=c(1,0),labels=c("Yes", "Not selected"))
names(data)[19] <- "Q4_SQ003"
# LimeSurvey Field type: F
data[, 20] <- as.numeric(data[, 20])
attributes(data)$variable.labels[20] <- "[None of the above] Which of the following source(s) fully funded its share of the allocated budget for the national statistical plan in 2023?"
data[, 20] <- factor(data[, 20], levels=c(1,0),labels=c("Yes", "Not selected"))
names(data)[20] <- "Q4_SQ004"
# LimeSurvey Field type: A
data[, 21] <- as.character(data[, 21])
attributes(data)$variable.labels[21] <- "Please provide the name of the national statistical plan:"
names(data)[21] <- "Q2a"
# LimeSurvey Field type: A
data[, 22] <- as.character(data[, 22])
attributes(data)$variable.labels[22] <- "Please provide the URL link to the national statistical plan:"
names(data)[22] <- "Q2b"
# LimeSurvey Field type: A
data[, 23] <- as.character(data[, 23])
attributes(data)$variable.labels[23] <- "Please provide any complementary information about the national statistical plan of your country"
names(data)[23] <- "Q2P3"
# LimeSurvey Field type: A
data[, 24] <- as.character(data[, 24])
attributes(data)$variable.labels[24] <- "Principle 1:  Relevance, impartiality and equal accessDoes your statistical legislation require official statistics to be compiled and published on an independent and impartial basis? "
data[, 24] <- factor(data[, 24], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[24] <- "Q1a"
# LimeSurvey Field type: A
data[, 25] <- as.character(data[, 25])
attributes(data)$variable.labels[25] <- "Principle 2:  Professional standards and ethicsDoes your statistical legislation require reliable methods and procedures that are in accordance with scientific and professional standards by which official statistics are to be collected, processed, and stored?"
data[, 25] <- factor(data[, 25], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[25] <- "Q1b"
# LimeSurvey Field type: A
data[, 26] <- as.character(data[, 26])
attributes(data)$variable.labels[26] <- "Principle 3: Accountability and transparencyDoes the statistical legislation contain provision(s) on how public statistics and methods are to be presented?"
data[, 26] <- factor(data[, 26], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[26] <- "Q1c"
# LimeSurvey Field type: A
data[, 27] <- as.character(data[, 27])
attributes(data)$variable.labels[27] <- "Principle 4: Prevention of misuseDoes your statistical legislation entitle statistical agencies to flag misuse of statistics?"
data[, 27] <- factor(data[, 27], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[27] <- "Q1d"
# LimeSurvey Field type: A
data[, 28] <- as.character(data[, 28])
attributes(data)$variable.labels[28] <- "Principle 5: Sources of official statisticsDoes your statistical legislation contain clear mandate for statistical agencies to collect data all kinds of sources according to established quality criteria?"
data[, 28] <- factor(data[, 28], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[28] <- "Q1e"
# LimeSurvey Field type: A
data[, 29] <- as.character(data[, 29])
attributes(data)$variable.labels[29] <- "Principle 6: Confidentiality Does your statistical legislation impose that collected data is strictly confidential and will be used exclusively for statistical purposes?"
data[, 29] <- factor(data[, 29], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[29] <- "Q1f"
# LimeSurvey Field type: A
data[, 30] <- as.character(data[, 30])
attributes(data)$variable.labels[30] <- "Principle 7: Legislation Is your statistical legislation publicly available?"
data[, 30] <- factor(data[, 30], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[30] <- "Q1g"
# LimeSurvey Field type: A
data[, 31] <- as.character(data[, 31])
attributes(data)$variable.labels[31] <- "Principle 8: National Coordination Does your statistical legislation require coordination among statistical agencies within your country? "
data[, 31] <- factor(data[, 31], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[31] <- "Q1h"
# LimeSurvey Field type: A
data[, 32] <- as.character(data[, 32])
attributes(data)$variable.labels[32] <- "Principle 9: Use of international standards Does your statistical legislation require the alignment of methods and classifications with international standards? "
data[, 32] <- factor(data[, 32], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[32] <- "Q1i"
# LimeSurvey Field type: A
data[, 33] <- as.character(data[, 33])
attributes(data)$variable.labels[33] <- "Principle 10: International cooperationDoes your statistical legislation require/encourage the engagements in bilateral and multilateral cooperation in statistics?"
data[, 33] <- factor(data[, 33], levels=c("AO1","AO2"),labels=c("Yes", "No"))
names(data)[33] <- "Q1j"
# LimeSurvey Field type: A
data[, 34] <- as.character(data[, 34])
attributes(data)$variable.labels[34] <- "Please provide a link to the statistical law:"
names(data)[34] <- "Q12ii"
# LimeSurvey Field type: A
data[, 35] <- as.character(data[, 35])
attributes(data)$variable.labels[35] <- "Please provide any complementary information about the national statistical law of your country. "
names(data)[35] <- "Q1P3"
# Variable name was incorrect and was changed from  to q_ .

