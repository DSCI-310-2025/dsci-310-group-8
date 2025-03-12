# "
# Script to train a logistic regression model.
# Usage:
#   04-model.R --input=<input> --output=<output>

# Options:
#   --input=<input>   Path to cleaned dataset.
#   --output=<output> Path to save model results.
# "

# library(docopt)
# library(caret)
# library(readr)

# doc <- docopt("s
# Usage:
#   0-model.R --input=<input> --output=<output>
# ")

# data <- read.csv(doc$input)
# model <- glm(income ~ ., data = data, family = binomial)
# saveRDS(model, doc$output)
# message("Model trained successfully.")
"
Script to train a logistic regression model.
Usage:
  04-model.R --input=<input> --output=<output>

Options:
  --input=<input>   Path to cleaned dataset.
  --output=<output> Path to save model results.
"

if (!requireNamespace("caret", quietly = TRUE)) {
  install.packages("caret", repos = "https://cloud.r-project.org")
}

library(docopt)
library(caret)
library(readr)
library(tidyverse)

doc <- docopt("s
Usage:
  04-model.R --input=<input> --output=<output>
")

data <- read.csv(doc$input)
message("Columns in dataset: ", paste(colnames(data), collapse = ", "))

if (!"income" %in% colnames(data)) {
  stop("Error: 'income' column is missing in the dataset.")
}
data <- data |>
  mutate(income = ifelse(income == ">50K", 1, 0))

model <- glm(income ~ ., data = data, family = binomial)
saveRDS(model, doc$output)
message("Model trained successfully.")
