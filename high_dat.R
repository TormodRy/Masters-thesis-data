###########
# Libraries
###########

library(fredr)
library(quantmod)
library(zoo)
library(dplyr)



#####################
# High frequency data
#####################



# Set your FRED API key

# You can obtain your API key by signing up at https://fred.stlouisfed.org/

api_key <- "d7cf41762f8f75d2051b9deaef966671"

fredr_set_key(api_key)



# Specify the series ID

series_ids <- c(
  'DCPF3M', #effective federal funds rate
  'DGS10', #Market yield on us treasury
  'CPFF', #3-Month Commercial Paper Minus Federal Funds Rate 
  'T3MFF', #3-Month Treasury Constant Maturity Minus Federal Funds Rate
  'T6MFF', #6-Month Treasury Constant Maturity Minus Federal Funds Rate
  'T1YFF', # 1-Year Treasury Constant Maturity Minus Federal Funds Rate
  'T5YFF', # 5-Year Treasury Constant Maturity Minus Federal Funds Rate
  'T10YFF', # 10-Year Treasury Constant Maturity Minus Federal Funds Rate
  'AAAFF', #Moody's Seasoned Aaa Corporate Bond Minus Federal Funds Rate
  'BAAFF',
  'DEXSZUS',  #Swiss Francs to U.S. Dollar Spot Exchange Rate
  'DEXJPUS', #jAPAN to U.S. Dollar Spot Exchange Rate
  'DEXUSUK', #U.S. Dollars to U.K. Pound Sterling Spot Exchange Rate
  'DEXCAUS', #U.S. Dollars to canada Spot Exchange Rate
  'DCOILWTICO', # Crude Oil Prices: West Texas Intermediate (WTI) - Cushing, Oklahoma
  'SP500', # S&P
  'VIXCLS', # VIX
  'WAAA', # Moody's Seasoned Aaa Corporate Bond Yield
  'WBAA' # Moody's Seasoned Baa Corporate Bond Yield
  
)

freq = 'w'

series_id <- 'WBAA'
# Fetch data from FRED
new_fred_dat <- fredr(series_id = series_id, frequency = freq)




# Initialize an empty list to store data and a vector to track failed series
list_of_dataframes <- list()
failed_series <- c()

# Loop through each series ID, fetch data, rename 'value' column, and store in list
for (series_id in series_ids) {
  tryCatch({
    temp_data <- fredr(series_id = series_id, frequency = 'w')
    if ("value" %in% names(temp_data)) {
      temp_data <- temp_data %>% rename(!!series_id := value)
      list_of_dataframes[[series_id]] <- temp_data
    } else {
      stop("Value column not found")
    }
  }, error = function(e) {
    failed_series <- c(failed_series, series_id)
  })
}

# Combine all dataframes into one, by merging on the date column
if (length(list_of_dataframes) > 0) {
  names(list_of_dataframes) <- series_ids[!series_ids %in% failed_series]
  high_dat <- Reduce(function(x, y) merge(x, y, by = "date", all = TRUE), list_of_dataframes)
}

# Print the combined dataframe and failed series
print(head(high_dat))


colnames(high_dat)
head(high_dat)
# Identify the columns to keep. For demonstration, let's say you've identified 
# the column names to keep as 'Date', 'DGS10', 'CPFF', etc.
# 
# <- c("Date", "DGS10", "CPFF", "T3MFF", "T6MFF", "T1YFF", "T5YFF", "T10YFF",
#                      "AAAFF", "BAAFF", "DEXSZUS", "DEXJPUS", "DEXUSUK")


columns_to_keep <- c("date", "DCPF3M","DGS10","CPFF","T3MFF","T6MFF","T1YFF","T5YFF","T10YFF","AAAFF",
"BAAFF","DEXSZUS","DEXJPUS","DEXUSUK","DEXCAUS","DCOILWTICO","SP500","VIXCLS","WAAA","WBAA")


# Subset the dataframe to keep only the identified columns
high_dat <- high_dat[, columns_to_keep]

# If you have a dynamic way to identify unique columns or a pattern, you can automate the identification
# For example, if unique series are identified by specific patterns in their names, or if the date columns 
# follow a specific naming convention that allows you to exclude them dynamically.

# Print the cleaned dataframe to verify
print(head(high_dat))

high_dat <- as.data.frame(high_dat, stringsAsFactors = FALSE)


##################
# Data adjustments
##################
# high_dat$SP500 <- NULL
# high_dat$DCPF3M <- NULL
# high_dat$CPFF <- NULL


# high_dat$date <- as.Date(high_dat$date, format="%Y/%m/%d")

str(high_dat)

# adjust start and end of time series 

# start_index <- which(high_dat$date == as.Date('1990-01-05'))
# high_dat <- high_dat[start_index:nrow(high_dat), ]
 
# sum(is.na(high_dat))

high_dat <- na.locf(high_dat, na.rm = FALSE)
 
high_dat$date <- as.Date(high_dat$date)

high_dat <- na.fill(high_dat, fill = 1)




#############
# Saving data
#############



# Save the data
write.csv(high_dat, file = 'C:/Users/tormo/OneDrive/Skole/Masteroppgave/Data/high_dat.csv',
          row.names = FALSE)



