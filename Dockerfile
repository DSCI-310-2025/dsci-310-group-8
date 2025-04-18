# Use a compatible base image
FROM rocker/rstudio:4.3.1

# Update system packages and install dependencies in a single layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libgit2-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install remotes package first
RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"

# Install tidyverse first to ensure its dependencies are properly resolved
RUN Rscript -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cloud.r-project.org')"

# Install all other R packages with version pinning
RUN Rscript -e "\
    remotes::install_version('docopt', version = '0.7.1', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('GGally', version = '2.1.2', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('broom', version = '1.0.5', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('repr', version = '1.1.6', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('infer', version = '1.0.4', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('gridExtra', version = '2.3', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('faraway', version = '1.0.8', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('mitools', version = '2.4', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('glmnet', version = '4.1.7', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('cowplot', version = '1.1.2', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('modelr', version = '0.1.11', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('ggplot2', version = '3.4.3', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('dplyr', version = '1.1.3', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('patchwork', version = '1.2.0', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('knitr', version = '1.43', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('rmarkdown', version = '2.23', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('markdown', version = '1.7', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('pROC', version = '1.18.5', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('testthat', version = '3.2.1', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('here', version = '1.0.1', repos = 'https://cloud.r-project.org'); \
    remotes::install_version('pointblank', version = '0.11.4', repos = 'https://cloud.r-project.org')"

# Verify installations
RUN Rscript -e "installed.packages()[,'Package']"

# Install incomepredictability package from GitHub
RUN Rscript -e "remotes::install_github('DSCI-310-2025/incomepredictability', ref = 'main')"

# Create a global .Renviron file to disable renv autoloader for all users
RUN echo 'RENV_CONFIG_AUTOLOADER_ENABLED=FALSE' >> /usr/local/lib/R/etc/Renviron

# Expose port 8787 for RStudio
EXPOSE 8787

# Start RStudio
CMD ["/init"]