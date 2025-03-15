# "
# Script to clean and preprocess the dataset.
# Usage:
#   02_clean_data.R --input=<input> --output=<output>

# Options:
#   --input=<input>   Path to raw dataset.
#   --output=<output> Path to save cleaned dataset.
# "

# library(docopt)
# library(dplyr)
# library(readr)

# doc <- docopt("
# Usage:
#   02_clean_data.R --input=<input> --output=<output>
# ")

# data <- read.csv(doc$input, na.strings = "?")
# data <- na.omit(data)

# if (!"income" %in% colnames(data)) {
#   stop("Error: The dataset does not contain an 'income' column.")
# }

# if (nrow(data) == 0) {
#   stop("Error: All rows were removed after cleaning. Check the dataset for missing values.")
# }

# data$income <- as.factor(data$income)

# write.csv(data, doc$output, row.names = FALSE)
# message("Dataset cleaned successfully.")

"
Script to clean and preprocess the dataset.
Usage:
  02-clean_data.R --input=<input> --output=<output>

Options:
  --input=<input>   Path to raw dataset.
  --output=<output> Path to save cleaned dataset.
"

library(docopt)
library(dplyr)
library(readr)

doc <- docopt("
Usage:
  02-clean_data.R --input=<input> --output=<output>
")

# Define column names (since the dataset lacks headers)
column_names <- c(
  "age", "workclass", "fnlwgt", "education", "education_num",
  "marital_status", "occupation", "relationship", "race", "sex",
  "capital_gain", "capital_loss", "hours_per_week", "native_country", "income"
)

# Read data with correct separator
data <- read.table(doc$input,
  header = FALSE, col.names = column_names,
  sep = ",", na.strings = "?"
)

# Print column names to verify successful read
message("Dataset loaded successfully.")
message("Columns in dataset: ", paste(colnames(data), collapse = ", "))

# Ensure `age` is numeric
data$age <- as.numeric(data$age)

# Check for NA values in `age`
if (any(is.na(data$age))) {
  warning("Warning: `age` contains NA values. These rows will be removed.")
  data <- data %>% filter(!is.na(age)) # Remove rows where `age` is NA
}

# Remove any remaining missing values
data <- na.omit(data)

# Ensure `income` column exists
if (!"income" %in% colnames(data)) {
  stop("Error: The dataset does not contain an 'income' column.")
}

# Convert `income` to factor
data$income <- as.factor(data$income)

# Save cleaned data
write.csv(data, doc$output, row.names = FALSE)
message("Dataset cleaned successfully.")
