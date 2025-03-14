#### 01_download_data.R

"
Script to download the U.S. Census Adult dataset and save it locally.
Usage:
  01-download_data.R --url=<url> --output=<output>

Options:
  --url=<url>       URL to download the dataset.
  --output=<output> Path to save the dataset.
"

library(docopt)
library(readr)

doc <- docopt("
Usage:
  01-download_data.R --url=<url> --output=<output>
")

url <- doc$url
output <- doc$output

download.file(url, output)
message("Dataset downloaded successfully.")