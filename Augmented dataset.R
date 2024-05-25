##########################
# Making augmented dataset
##########################

library(data.table)

# Load your data

dat <- fread('C:/Users/tormo/OneDrive/Skole/Masteroppgave/Data/long_low_dat23.csv')

# Set seed for reproducibility
set.seed(123)

# Function to bootstrap data and combine into one dataframe
bootstrap_and_combine <- function(data, n_bootstraps=100) {
  # n_bootstraps: number of bootstrap samples to generate
  large_dataset <- data.table()  # Initialize an empty data.table
  for (i in 1:n_bootstraps) {
    # Sample with replacement from the original data
    boot_indices <- sample(1:nrow(data), replace=TRUE, size=nrow(data))
    boot_sample <- data[boot_indices, ]
    boot_sample[, bootstrap_id := i]  # Add a bootstrap identifier column
    large_dataset <- rbind(large_dataset, boot_sample, fill=TRUE)
  }
  return(large_dataset)
}

# Generate combined bootstrap samples
combined_bootstrapped_data <- bootstrap_and_combine(dat, n_bootstraps=10)  # Change n_bootstraps to your desired number

# View the combined data
print(combined_bootstrapped_data)

write.csv(combined_bootstrapped_data, file = 'C:/Users/tormo/OneDrive/Skole/Masteroppgave/Data/aug_dat.csv')
write.csv()