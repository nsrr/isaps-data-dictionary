ver="0.1.0"

library(haven)
library(readr)
library(dplyr)
library(tidyr)
library(lubridate)


data <- read.csv("/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20191126-barger-data/nsrr-prep/_source/age_gender_interns 20240130.csv")
data$timepoint <-1

edf <- read.csv("/VOLUMES/BWH-SLEEPEPI-NSRR-STAGING/20191126-barger-data/edf-header-info/barger-filenames-processed.csv")
id <- unique(substr(edf$ID, 1, 5))
data$raw_folder_name <- NA
data$filename_id <- NA

for (i in 1:nrow(data)) {
  subject <- data$subject[i]
  match_id <- id[grep(paste0("^[0-9]{2}", subject, "I$"), id)]
  if (length(match_id) > 0) {
    data$raw_folder_name[i] <- paste0(match_id, "_EDF")
    data$filename_id[i] <- match_id
  }
}
data$raw_folder_name[data$subject == "O1"] <- "23O1I_EDF"
data$filename_id[data$subject == "O1"] <- "23O1I"

write.csv(data,file = "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20191126-barger-data/nsrr-prep/_releases/0.1.0/isaps-dataset-0.1.0.csv", row.names = FALSE, na='')

# Harmonized data
harmonized_data<-data[,c("subject","age", "gender","timepoint")]%>%
  dplyr::mutate(nsrrid=subject,
                nsrr_age=age,
                nsrr_sex=dplyr::case_when(
                  gender==0 ~ "male",
                  gender==1 ~ "female",
                  TRUE ~ "not reported"
                )) %>% select(nsrrid,timepoint,nsrr_age,nsrr_sex)

write.csv(harmonized_data, file = "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20191126-barger-data/nsrr-prep/_releases/0.1.0.pre/isaps-harmonized-dataset-0.1.0.csv", row.names = FALSE, na='')


#to check the unmatched subject id and edf
#id_subjects <- gsub("^[0-9]{2}(.+)I$", "\\1", id)
#unmatched_ids <- id[!(id_subjects %in% data$subject)]
#print("EDFs without matching subjects:")
#print(unmatched_ids)
