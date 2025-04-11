"
Script to clean and preprocess the dataset.
Usage:
  02-clean_data.R --input=<input> --output=<output>

Options:
  --input=<input>   Path to raw dataset.
  --output=<output> Path to save cleaned dataset.
"

library(docopt)
library(readr)
library(incomepredictability)
library(pointblank)
library(dplyr)

doc <- docopt("
Usage:
  02_clean_data.R --input=<input> --output=<output>
")
raw_data <- read_csv(doc$input, col_names = FALSE)

# Raw Data Validation
# Checklist #1: Correct Data File Format
if (!inherits(raw_data, "data.frame")) {
  stop("The input raw_data is not a data frame or tibble as expected!")
}

raw_agent <- create_agent(
  tbl = raw_data,
  tbl_name = "Raw Data",
  # Set at 50 to accommodate incorrectly flagged duplicates
  actions = action_levels(warn_at = 50, stop_at = 50, notify_at = 50)) %>%

  # Checklist #2: Correct column names (raw data headers are X1, X2, ..., X15) #nolint
  col_exists(columns = paste0("X", 1:15)) %>%

  # Checklist #3: No empty observations (checks for completely NA rows)
  rows_complete()

# Checklist #4: Missingness not beyond expected threshold (set to 95%)
# Can't use col_vals_not_null yet (done in clean data validation)--might have some missingness in the raw data
missing_thresholds <- raw_data %>%
  summarise(across(everything(), ~ sum(!is.na(.)) / n()))
if (!all(missing_thresholds >= 0.95)) {
  stop("One or more columns do not meet the 95% non-missing threshold.")
}

# Checklist #5: Correct column data types (expected types based on spec)
raw_agent <- raw_agent %>%
  col_is_numeric(columns = vars(X1, X3, X5, X11, X12, X13)) %>%
  col_is_character(columns = vars(X2, X4, X6, X7, X8, X9, X10, X14, X15)) %>%

  # Checklist #6: No duplicate observations
  # Duplicate row validation flagged by pointblank, but after investigation these observations were deemed distinct
  # Hence we will increase the threshold to avoid any warnings or stopping the workflow
  rows_distinct() %>%

  # Checklist #7: No outliers or anomalous values
  col_vals_between(columns = vars(X1), left = 0, right = 100) %>% # age (X1): 0-100
  col_vals_between(columns = vars(X3), left = 1, right = Inf) %>%   # fnlwgt (X3): positive
  col_vals_between(columns = vars(X5), left = 1, right = 16) %>% # education_num (X5): 1-16
  col_vals_between(columns = vars(X11), left = 0, right = Inf) %>% # capital_gain (X11): 0 or positive
  col_vals_between(columns = vars(X12), left = 0, right = Inf) %>% # capital_loss (X12): 0 or positive
  col_vals_between(columns = vars(X13), left = 1, right = 100) %>% # hours_per_week (X13) 1-100

  # Checklist #8a: Correct category levels (i.e., no string mismatches and within the allowed set)
  # Check for workclass values (X2)
  col_vals_in_set(
    columns = vars(X2),
    set = c("State-gov", "Self-emp-not-inc", "Private", "Federal-gov",
      "Local-gov", "?", "Self-emp-inc", "Without-pay", "Never-worked"), # after investigation ? was deemed a plausible value for the data
    label = "Workclass values check") %>%
  # Check for education values (X4)
  col_vals_in_set(
    columns = vars(X4),
    set = c("Bachelors", "HS-grad", "11th", "Masters", "9th", "Some-college",
      "Assoc-acdm", "Assoc-voc", "7th-8th", "Doctorate", "Prof-school",
      "5th-6th", "10th", "1st-4th", "Preschool", "12th"),
    label = "Education values check") %>%
  # Check for marital-status values (X6)
  col_vals_in_set(
    columns = vars(X6),
    set = c("Never-married", "Married-civ-spouse", "Divorced", "Married-spouse-absent",
      "Separated", "Married-AF-spouse", "Widowed"),
    label = "Marital status values check") %>%
  col_vals_in_set(
    columns = vars(X7),
    set = c("Adm-clerical", "Exec-managerial", "Handlers-cleaners",
      "Prof-specialty", "Other-service", "Sales",
      "Craft-repair", "Transport-moving", "Farming-fishing",
      "Machine-op-inspct", "Tech-support", "?", # after investigation ? was deemed a plausible value for the data
      "Protective-serv", "Armed-Forces", "Priv-house-serv"),
    label = "Occupation values check") %>%
  # Check for relationship values (X8)
  col_vals_in_set(
    columns = vars(X8),
    set = c("Not-in-family", "Husband", "Wife", "Own-child",
      "Unmarried", "Other-relative"),
    label = "Relationship values check") %>%
  # Check for race values (X9)
  col_vals_in_set(
    columns = vars(X9),
    set = c("White", "Black", "Asian-Pac-Islander", "Amer-Indian-Eskimo", "Other"),
    label = "Race values check") %>%
  # Check for sex values (X10)
  col_vals_in_set(
    columns = vars(X10),
    set = c("Male", "Female"),
    label = "Sex values check") %>%
  # Check for native-country values (X14)
  col_vals_in_set(
    columns = vars(X14),
    set = c("United-States", "Cuba", "Jamaica", "India", "?", "Mexico", "South", 
      "Puerto-Rico", "Honduras", "England", "Canada", "Germany", "Iran",
      "Philippines", "Italy", "Poland", "Columbia", "Cambodia", "Thailand",
      "Ecuador", "Laos", "Taiwan", "Haiti", "Portugal", "Dominican-Republic",
      "El-Salvador", "France", "Guatemala", "China", "Japan", "Yugoslavia",
      "Peru", "Outlying-US(Guam-USVI-etc)", "Scotland", "Trinadad&Tobago",
      "Greece", "Nicaragua", "Vietnam", "Hong", "Ireland", "Hungary",
      "Holand-Netherlands"),
    label = "Native-country values check") %>%
  # Check for income values (X15)
  col_vals_in_set(
    columns = vars(X15),
    set = c("<=50K", ">50K"),
    label = "Income values check")

# Checklist #8b: Correct category levels (i.e., no single values)
unique_counts <- raw_data %>%
  summarise(
    workclass_n = n_distinct(X2),
    education_n = n_distinct(X4),
    marital_status_n = n_distinct(X6))
if (any(unique_counts < 2)) {
  stop("One or more categorical columns contains only a single unique value.")
}

# Run the raw data validation
raw_agent <- interrogate(raw_agent)

# Cleaning
clean_data <- na.omit(raw_data)
colnames(clean_data) <- c(
  "age", "workclass", "fnlwgt", "education", "education_num",
  "marital_status", "occupation", "relationship", "race", "sex", "capital_gain", # nolint
  "capital_loss", "hours_per_week", "native_country", "income")
clean_data$income <- as.factor(clean_data$income)

# Clean Data Validation
clean_agent <- create_agent(
  tbl = clean_data,
  tbl_name = "Cleaned Data",
  actions = action_levels(warn_at = 1, stop_at = 1, notify_at = 1)) %>%
  # Validate column renaming
  col_exists(
    columns = c("age", "workclass", "fnlwgt", "education", "education_num",
      "marital_status", "occupation", "relationship", "race", "sex",
      "capital_gain", "capital_loss", "hours_per_week", "native_country",
      "income")) %>%
  # Validate row completeness, should work because of na.omit()
  rows_complete() %>%
  # Validate 100% completeness of data (Checklist #4 confirmed)
  col_vals_not_null(
    columns = c("age", "workclass", "fnlwgt", "education", "education_num",
      "marital_status", "occupation", "relationship", "race", "sex",
      "capital_gain", "capital_loss", "hours_per_week", "native_country",
      "income")) %>%
  # Validate correct column types + successful factor data type for target
  col_is_numeric(columns = vars(age, fnlwgt, education_num, capital_gain, capital_loss, hours_per_week)) %>%
  col_is_character(columns = vars(workclass, education, marital_status, occupation, relationship, race, sex, native_country)) %>%
  col_is_factor(columns = vars(income))%>%
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
# Run the clean data validation
clean_agent <- interrogate(clean_agent)

write.csv(clean_data, doc$output, row.names = FALSE)
message("Dataset cleaned successfully.")
