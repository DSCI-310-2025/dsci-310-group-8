"
Script to create our training set from the raw data
Usage:
  analysis/03-training_split.R --input=<input> --output_train=<output> --output_test=<output>


Options:
  --input=<input>   Path to cleaned dataset.
  --output_train=<output> Path to save training dataset.
  --output_test=<output> Path to save testing dataset
"

library(docopt)
library(dplyr)
library(readr)
library(pointblank)

# source("R/train_test_split.R")
library(incomepredictability)

doc <- docopt("
Usage:
  analysis/03-training_split.R --input=<input> --output_train=<output> --output_test=<output>
")

set.seed(1234)

cleaned_data <- read_csv(doc$input)
sample_size <- round(0.1 * nrow(cleaned_data))
income_sample <- cleaned_data %>%
  sample_n(size = sample_size) %>%
  # Initial data validation revealed our target wasn't a factor despite the earlier cleaning steps
  # The flow of data through our analysis pipeline might have changed the target data type
  # Hence we re-apply the factor conversion to the sample
  mutate(income = as.factor(income))

splits <- train_test_split(income_sample, 0.8)

train_data <- splits$train
# Training Data Validation
train_agent <- create_agent(
  tbl = train_data,
  tbl_name = "Training Data",
  actions = action_levels(warn_at = 1, stop_at = 1, notify_at = 1)) %>%
  # Check for expected column names
  col_exists(
    columns = c("age", "workclass", "fnlwgt", "education", "education_num",
                "marital_status", "occupation", "relationship", "race", "sex",
                "capital_gain", "capital_loss", "hours_per_week", "native_country", "income")) %>%
  # Check that every row is complete (should be, after cleaning)
  rows_complete() %>%
  # Check for 100% non-missing values
  col_vals_not_null(
    columns = c("age", "workclass", "fnlwgt", "education", "education_num",
                "marital_status", "occupation", "relationship", "race", "sex",
                "capital_gain", "capital_loss", "hours_per_week", "native_country", "income")) %>%
  # Validate data types
  col_is_numeric(
    columns = vars(age, fnlwgt, education_num, capital_gain, capital_loss, hours_per_week)) %>%
  col_is_character(
    columns = vars(workclass, education, marital_status, occupation, relationship, race, sex, native_country)) %>%
  col_is_factor(
    columns = vars(income)) %>%
  # No duplicate observations
  rows_distinct() %>%
  # No outliers or anomalous values
  col_vals_between(columns = vars(age), left = 0, right = 100) %>% # age (X1): 0-100
  col_vals_between(columns = vars(fnlwgt), left = 1, right = Inf) %>%   # fnlwgt (X3): positive
  col_vals_between(columns = vars(education_num), left = 1, right = 16) %>% # education_num (X5): 1-16
  col_vals_between(columns = vars(capital_gain), left = 0, right = Inf) %>% # capital_gain (X11): 0 or positive
  col_vals_between(columns = vars(capital_loss), left = 0, right = Inf) %>% # capital_loss (X12): 0 or positive
  col_vals_between(columns = vars(hours_per_week), left = 1, right = 100) # hours_per_week (X13) 1-100

# We choose to omit category level and value check because we standardize all categorical values in the previous validation and in cleaning
# Rechecking them on the cleaned data and subsequent splits would be redundant
# Run the training data validation
train_agent <- interrogate(train_agent)

test_data <- splits$test
# Testing Data Validation
test_agent <- create_agent(
  tbl = test_data,
  tbl_name = "Testing Data",
  actions = action_levels(warn_at = 1, stop_at = 1, notify_at = 1)
) %>%
  # Check for expected column names
  col_exists(
    columns = c("age", "workclass", "fnlwgt", "education", "education_num",
                "marital_status", "occupation", "relationship", "race", "sex",
                "capital_gain", "capital_loss", "hours_per_week", "native_country", "income")) %>%
  # Check that every row is complete
  rows_complete() %>%
  # Check for 100% non-missing values
  col_vals_not_null(
    columns = c("age", "workclass", "fnlwgt", "education", "education_num",
                "marital_status", "occupation", "relationship", "race", "sex",
                "capital_gain", "capital_loss", "hours_per_week", "native_country", "income")) %>%
  # Validate data types
  col_is_numeric(
    columns = vars(age, fnlwgt, education_num, capital_gain, capital_loss, hours_per_week)) %>%
  col_is_character(
    columns = vars(workclass, education, marital_status, occupation, relationship, race, sex, native_country)) %>%
  col_is_factor(
    columns = vars(income)) %>%
  # No duplicate observations
  rows_distinct() %>%
  # No outliers or anomalous values
  col_vals_between(columns = vars(age), left = 0, right = 100) %>% # age (X1): 0-100
  col_vals_between(columns = vars(fnlwgt), left = 1, right = Inf) %>%   # fnlwgt (X3): positive
  col_vals_between(columns = vars(education_num), left = 1, right = 16) %>% # education_num (X5): 1-16
  col_vals_between(columns = vars(capital_gain), left = 0, right = Inf) %>% # capital_gain (X11): 0 or positive
  col_vals_between(columns = vars(capital_loss), left = 0, right = Inf) %>% # capital_loss (X12): 0 or positive
  col_vals_between(columns = vars(hours_per_week), left = 1, right = 100) # hours_per_week (X13) 1-100

  # We choose to omit category level and value check because we standardize all categorical values in the previous validation and in cleaning
  # Rechecking them on the cleaned data and subsequent splits would be redundant
  # Run the testing data validation
  test_agent <- interrogate(test_agent)

write.csv(train_data, doc$output_train, row.names = FALSE)
write.csv(test_data, doc$output_test, row.names = FALSE)
message("Dataset split successfully.")
