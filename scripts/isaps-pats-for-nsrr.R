ver="0.1.0"

library(haven)
library(readr)
library(dplyr)
library(tidyr)
library(lubridate)


data <- read.csv("/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20191126-barger-data/nsrr-prep/_source/age_gender_interns 20240130.csv")
data$timepoint <-1
write.csv(data,file = "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20191126-barger-data/nsrr-prep/_releases/0.1.0.pre/isaps-dataset-0.1.0.pre.csv", row.names = FALSE, na='')

# Harmonized data
harmonized_data<-data[,c("subject","age", "gender","timepoint")]%>%
  dplyr::mutate(nsrrid=subject,
                nsrr_age=age,
                nsrr_sex=dplyr::case_when(
                  gender==0 ~ "male",
                  gender==1 ~ "female",
                  TRUE ~ "not reported"
                )) %>% select(nsrrid,timepoint,nsrr_age,nsrr_sex)

write.csv(harmonized_data, file = "/Volumes/BWH-SLEEPEPI-NSRR-STAGING/20191126-barger-data/nsrr-prep/_releases/0.1.0.pre/isaps-harmonized-dataset-0.1.0.pre.csv", row.names = FALSE, na='')
