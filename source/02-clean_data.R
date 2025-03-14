"
Script to clean and preprocess the dataset.
Usage:
  02_clean_data.R --input=<input> --output=<output>

Options:
  --input=<input>   Path to raw dataset.
  --output=<output> Path to save cleaned dataset.
"

library(docopt)
library(dplyr)
library(readr)

doc <- docopt("
Usage:
  02_clean_data.R --input=<input> --output=<output>
")

data <- read.csv(doc$input, na.strings = "?")
data <- na.omit(data)
data$income <- as.factor(data$income)

write.csv(data, doc$output, row.names = FALSE)
message("Dataset cleaned successfully.")