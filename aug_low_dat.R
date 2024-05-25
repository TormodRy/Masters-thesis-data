#########################
# Bootstrapping FRED data
#########################

library(data.table)

# Load your data
low_dat <- fread('C:/Users/tormo/OneDrive/Skole/Masteroppgave/Data/complete_low_dat.csv')

# Split your data
train_dat <- low_dat[1:564]
test_dat <- low_dat[565:nrow(low_dat)]

# Adjusted Block Bootstrap Function
block_bootstrap_df <- function(df, block_length, n_samples) {
  n <- nrow(df)
  new_data <- data.table()  # Use data.table for consistency
  
  while (nrow(new_data) < n_samples) {
    start_index <- sample(1:n, 1)  # Random starting index
    end_index <- min(n, start_index + block_length - 1)
    if (end_index < start_index + block_length - 1) {
      # Wrap around the end of the data table
      wrap_around <- (start_index + block_length - 1) %% n
      new_data <- rbind(new_data, df[start_index:n, ], df[1:wrap_around, ])
    } else {
      new_data <- rbind(new_data, df[start_index:end_index, ])
    }
  }
  
  # Truncate to the exact number of samples needed
  return(new_data[1:n_samples])
}

# Define parameters
block_length <- as.integer(sqrt(nrow(train_dat)))  # Choosing block length
desired_length <- 4 * nrow(train_dat)  # Set to double the original training data size

# Perform bootstrapping
bootstrapped_data <- block_bootstrap_df(train_dat, block_length, desired_length)


# Mark data sources
bootstrapped_data[, Source := "Bootstrapped"]
train_dat[, Source := "Training"]
test_dat[, Source := "Testing"]

# Combine all data into one data.table in the order: Bootstrapped, Training, Testing
combined_data <- rbind(bootstrapped_data, train_dat, test_dat)

# Review the combined structure and summary
print(head(combined_data, 10))
print(tail(combined_data, 10))
print(summary(combined_data))



# # Save the data
write.csv(combined_data, file = 'C:/Users/tormo/OneDrive/Skole/Masteroppgave/Data/aug_low_dat.csv',
          row.names = FALSE)
