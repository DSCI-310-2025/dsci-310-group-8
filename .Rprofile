# Comment out or remove the renv activation
# source("renv/activate.R")

# Disable renv autoloader
Sys.setenv(RENV_CONFIG_AUTOLOADER_ENABLED = "FALSE")

# Load packages needed by all scripts
if (!require("incomepredictability")) {
  if (!require("remotes")) {
    install.packages("remotes", repos = "https://cloud.r-project.org")
  }
  remotes::install_github("DSCI-310-2025/incomepredictability")
  library(incomepredictability)
}

# Inform the user that renv is disabled
message("Note: renv has been disabled to ensure all necessary packages are available.")