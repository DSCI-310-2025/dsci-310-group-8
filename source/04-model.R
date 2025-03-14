"
Script to train a logistic regression model.
Usage:
  04-model.R --input=<input> --output=<output>

Options:
  --input=<input>   Path to cleaned dataset.
  --output=<output> Path to save model results.
"

library(docopt)
library(caret)
library(readr)

doc <- docopt("s
Usage:
  0-model.R --input=<input> --output=<output>
")

data <- read.csv(doc$input)
model <- glm(income ~ ., data = data, family = binomial)
saveRDS(model, doc$output)
message("Model trained successfully.")
