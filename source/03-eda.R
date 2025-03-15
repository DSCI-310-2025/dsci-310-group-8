# "
# Script to perform exploratory data analysis (EDA).
# Usage:
#   03-eda.R --input=<input> --output=<output>

# Options:
#   --input=<input>   Path to cleaned dataset.
#   --output=<output> Path to save visualizations.
# "

# library(docopt)
# library(ggplot2)
# library(dplyr)
# library(readr)

# doc <- docopt("
# Usage:
#   03-eda.R --input=<input> --output=<output>
# ")

# data <- read.csv(doc$input)
# ggplot(data, aes(x = age, fill = income)) + geom_histogram(bins = 30) + ggsave(doc$output)
# message("EDA completed successfully.")
"
Script to perform exploratory data analysis (EDA).
Usage:
  03-eda.R --input=<input> --output=<output>

Options:
  --input=<input>   Path to cleaned dataset.
  --output=<output> Path to save visualizations.
"

library(docopt)
library(ggplot2)
library(dplyr)
library(readr)

doc <- docopt("
Usage:
  03-eda.R --input=<input> --output=<output>
")

# Read dataset
data <- read.csv(doc$input)

# Ensure `age` is numeric
data$age <- as.numeric(data$age)

# Check if `age` is still valid
if (any(is.na(data$age))) {
  stop("Error: `age` contains NA values after conversion. Check dataset formatting.")
}

# Generate histogram
ggplot(data, aes(x = age, fill = income)) +
  geom_histogram(bins = 30) +
  theme_minimal()

# Save plot
ggsave(doc$output)

message("EDA completed successfully.")
