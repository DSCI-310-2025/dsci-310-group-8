# dsci-310-group-8

# Project Title: U.S. Adult Census Income Prediction with Logistic Regression

# List of contributors/authors:
    - Michael Tham
    - Yui Mikuriya
    - Benjamin Gerochi
    - Izzy Zhou

# Project Summary:
This project aims to investigate income prediction using the UCI Adult Dataset, which compiles demographic and income data from the 1994 U.S. Census. The primary objective is to predict whether an individual earns over $50,000 annually using factors such as age, education level, and hours worked per week. By employing a logistic regression model, we aim to effectively predict income levels on test cases while assessing model performance using metrics like the ROC curve (AUC ≈ 0.79), sensitivity, specificity, and accuracy.

Some tools we will use include:
- R programming language for data loading, wrangling, cleaning, and analysis.
- Docker to containerize our environments.
- A variety of R packages, including tidyverse, broom, and repr.

Summary of Findings and Implications:
- Our logistic regression model demonstrated strong predictive power (AUC = 0.7965), highlighting that key factors like education level, age, and hours worked significantly influence income levels.
- Higher education and increased work hours are strongly linked to higher income, reinforcing the importance of skill development and labor market participation.
- These findings suggest that policy efforts aimed at reducing income inequality should focus on education accessibility and work-life balance initiatives.

Expectations and Results:
- The results align with expectations:
- Age & Experience: Older individuals generally earn more due to accumulated experience.
- Education: Those with higher degrees earn significantly more.
- Work Hours: More hours worked often lead to higher pay.

Future Research:
- Geographic Factors: Examining regional disparities in income may provide insights into location-based economic opportunities.
- Demographic Intersections: Investigating how race, gender, and marital status interact with income could enhance model accuracy.
- Health & Disability: Including health variables could highlight additional barriers affecting earnings potential.

# Docker Container Setup  
This project uses Docker to ensure a consistent and reproducible computational environment. The Docker image contains all necessary R packages and dependencies to run the analysis. 

## Using Docker with Docker Compose (Recommended)

The easiest way to use our Docker container is with Docker Compose:

1. **Install Docker and Docker Compose** on your system if you haven't already:
   - [Docker Installation Guide](https://docs.docker.com/get-docker/)
   - [Docker Compose Installation Guide](https://docs.docker.com/compose/install/)

2. **Run the container** by navigating to the project directory and executing:

   ```bash
   docker-compose up
   ```

3. **Access RStudio** by opening a web browser and going to: 
   - http://localhost:8787

Use the following credentials:
- Username: rstudio
- Password: group8

## Using Docker directly

If you prefer to use Docker without Docker Compose:

1. **Pull the image from Docker Hub**:

   ```bash
   docker pull zx2yizzy/dsci-310-group-8-project-docker:latest
   ```

2. **Run the container**:

    ```bash
    docker run -d -p 8787:8787 -e PASSWORD=rstudio -v $(pwd):/home/rstudio/project zx2yizzy/dsci-310-group-8-project-docker:latest
    ```

3. **Access RStudio** by opening a web browser and going to:

    ```bash
    http://localhost:8787
    ```

## Building the image locally
If you want to build the Docker image locally:

1. **Clone the repository**:

    ```bash
    git clone https://github.com/DSCI-310-2025/dsci-310-group-8.git
    cd dsci-310-group-8
    ```

2. **Build the image**:

    ```bash
    docker build -t dsci-310-group-8-project-docker .
    ```

3. **Run the container**:

    ```bash
    docker run -d -p 8787:8787 -e PASSWORD=group8 -v $(pwd):/home/rstudio/project dsci-310-group-8-project-docker
    ```

# How to Run the Analysis
To reproduce the analysis, follow these steps:

1. **Clone the repository**:

    ```bash
    git clone https://github.com/DSCI-310-2025/dsci-310-group-8.git
    cd dsci-310-group-8
    ```

2. **Set Up the Environment**:

Use the Docker container as described in the "Docker Container Setup" section above
Access the RStudio server at http://localhost:8787

3. **Run the Analysis**:

Open the RStudio environment
Navigate to the src directory and run the analysis scripts (e.g., analysis.R)

# Dependencies
The following dependencies are required to run the analysis:

## Software:
    - Docker
    - R (version 4.3.1 or higher)
    - Docker Compose (recommended)

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
    - pROC

# Licenses
This project is licensed under the terms of the Creative Commons Legal Code. See the LICENSE.md file for details.

# Contributing
Contributions to this project are welcome. Please follow the CONTRIBUTING.md if you'd like to contribute.

# Acknowledgments
This project was completed as part of DSCI 310 at the University of British Columbia.
