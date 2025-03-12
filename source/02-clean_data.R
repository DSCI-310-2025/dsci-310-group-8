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

column_names <- c(
  "age", "workclass", "fnlwgt", "education", "education_num",
  "marital_status", "occupation", "relationship", "race", "sex",
  "capital_gain", "capital_loss", "hours_per_week", "native_country", "income"
)

data <- read.table(doc$input,
  header = FALSE, col.names = column_names,
  sep = ",", na.strings = "?"
)

message("Dataset loaded successfully.")
message("Columns in dataset: ", paste(colnames(data), collapse = ", "))

data$age <- as.numeric(data$age)

if (any(is.na(data$age))) {
  warning("Warning: `age` contains NA values. These rows will be removed.")
  data <- data %>% filter(!is.na(age)) # Remove rows where `age` is NA
}

data <- na.omit(data)

if (!"income" %in% colnames(data)) {
  stop("Error: The dataset does not contain an 'income' column.")
}

data$income <- as.factor(data$income)

write.csv(data, doc$output, row.names = FALSE)
message("Dataset cleaned successfully.")
