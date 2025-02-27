# dsci-310-group-8

# Project title: U.S. Adult Census Income Prediction with Logistic Regression

# List of contributors/authors:
    - Michael Tham
    - Yui Mikuriya
    - Benjamin Gerochi
    - Izzy Zhou

# Project Summary:
This project aims to investigate income prediction using the UCI Adult Dataset, which compiles demographic and income data from the 1994 U.S. Census. The primary objective is to predict whether an individual earns over $50,000 annually using factors such as age, education level, and hours worked per week. By employing a logistic regression model, in our analysis we aim to effectively predic income levels on test cases while assessing model performance using metrics like the ROC curve (AUC ≈ 0.79), sensitivity, specificity, and accuracy.

Some tools we will use are the R programming language for data loading, wrangling, cleaning, and analysis as well as Docker to containerize our environments. Furthermore, we will use a plethora of R packages such as tidyverse, broom, and repr.

# How to Run the Analysis  
To reproduce the analysis, follow these steps:  

1. **Clone the repository**:  
   ```bash
   git clone https://github.com/DSCI-310-2025/dsci-310-group-8.git
   cd dsci-310-group-8

2. **Set Up the Environment**:
    - Install Docker
    - Build Docker Image: docker build -t dsci-310-group-8-project-docker .
    - Run the Docker Container: docker run -it -p 8787:8787 dsci-310-group-8-project-docker
    - Access the RStudio server at http://localhost:8787.

3. **Run the Analysis**:
    - Open the RStudio environment
    - Navigate to the src directory and run the analysis scripts (e.g., analysis.R)

# Dependencies
The following dependencies are required to run the analysis:

## Software:
    - Docker
    - R (version 4.3.1 or higher)

## R Packages:
    - tidyverse
    - ggplot2
    - dplyr
    - knitr
    - broom
    - repr
    - infer
    - gridExtra
    - farway
    - mitools
    - glmnet
    - cowplot
    - modelr
    - patchwork
    - knitr

# Licenses
This project is licensed under the terms of the MIT License. See the LICENSE.md file for details.

# Contributing
Contributions to this project are welcome. Please follow the CONTRIBUTING.md if you'd like to contribute.

# Acknowledgments
This project was completed as part of DSCI 310 at the University of British Columbia.
