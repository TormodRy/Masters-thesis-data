
###########
# Libraries
###########
library(fredr)
library(zoo)
library(data.table)
library(dplyr)
library(ggplot2)

##############
# Merging data
##############

# Link: https://research.stlouisfed.org/econ/mccracken/fred-databases/
low_dat <- read.csv(file = 'C:/Users/tormo/OneDrive/Skole/Masteroppgave/Data/current.csv')
date <- low_dat$date
low_dat <- setDT(low_dat)
colnames(low_dat)
ncol(low_dat)
sum(is.na(low_dat)) # How should i handle missing observations?

# LOCF
low_dat <- na.locf(low_dat)
sum(is.na(low_dat))

low_dat$date <- low_dat$sasdate
low_dat <- low_dat %>% select(date, everything()) #putting date first
low_dat$sasdate <- NULL #removing sasdate

# column 'date' in Date format
low_dat <- low_dat %>% 
  mutate(date = as.Date(date, format="%m/%d/%Y")) %>%
  filter(date >= as.Date("1959-1-1"))

#######################################
# Full size data set (complete_low_dat)
#######################################


##################
# Stationary data
##################

# Specify the column names you want to select
selected_cols <- c(
  "VIXCLSx", "EXCAUSx", "EXUSUKx", "EXJPUSx", "EXSZUSx", "TWEXAFEGSMTHx",
  "BAAFFM", "AAAFFM", "T5YFFM", "T10YFFM", "T1YFFM", "TB6SMFFM", "TB3SMFFM", "COMPAPFFx", "BAA", "AAA", "GS10",
  "GS5", "GS1", "TB6MS", "TB3MS", "CP3Mx", "FEDFUNDS", "S.P.PE.ratio", "S.P.div.yield", "CONSPI", "ISRATIOx",
  "PERMITW", "PERMITS", "PERMITMW", "PERMITNE", "PERMIT", "HOUSTMW", "HOUSTW", "HOUSTS", "HOUSTNE", "HOUST",
  "AWHMAN", "AWOTMAN", "CES0600000007", "NDMANEMP", "DMANEMP", "MANEMP", "CES1021000001", "CLAIMSx", "UEMP27OV",
  "UEMP15T26", "UEMP15OV", "UEMP5TO14", "UEMPLT5", "UEMPMEAN", "UNRATE", "CUMFNS", 'date'
)
  
# Create a new data frame containing only the selected columns
selected_data <- low_dat[, ..selected_cols, with = FALSE]
selected_data$date <- as.Date(selected_data$date)
selected_data <- selected_data %>% select(date, everything()) #putting date first

selected_data <- selected_data[13:nrow(selected_data)]

# Remove the selected columns from low_dat
low_dat <- low_dat[, !(names(low_dat) %in% selected_cols), with = FALSE]

  
##############
# YoY format
##############

complete_low_dat <- low_dat[, lapply(.SD, function(x) {
  if (is.numeric(x)) { 
    # Ensuring the operation is applied correctly
    shifted_x <- shift(x, n = 12)
    return((x - shifted_x) / shifted_x * 100)
  } else {
    return(x)
  }
}), .SDcols = sapply(low_dat, is.numeric)]  # Apply only to numeric columns

# low_dat[is.infinite(low_dat)] <- 0

complete_low_dat <- complete_low_dat[13:nrow(low_dat),]

# complete_low_dat <- na.locf(complete_low_dat)
# sum(is.na(complete_low_dat))

# comp_date <- comp_date[51:length(comp_date)]
complete_low_dat$date <- selected_data$date
complete_low_dat$date <- as.Date(complete_low_dat$date, format = '%Y-%m-%d')


low_dat <- merge(complete_low_dat, selected_data, by = 'date', all.x = TRUE)
dat6310 <- low_dat[1:600]
dat6323 <- low_dat[1:nrow(low_dat)]

############
#Saving data
############

# # Save the data
write.csv(dat6310, file = 'C:/Users/tormo/OneDrive/Skole/Masteroppgave/Data/short_low_dat10.csv',
          row.names = FALSE)
# 
# # Save the data
write.csv(dat6323, file = 'C:/Users/tormo/OneDrive/Skole/Masteroppgave/Data/long_low_dat23.csv',
          row.names = FALSE)


