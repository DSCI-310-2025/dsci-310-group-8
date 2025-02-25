# Use a compatible base image
FROM rocker/rstudio:4.3.1

# Update system packages and install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install remotes package first
RUN Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"

# Install R packages with pinned versions
RUN Rscript -e "remotes::install_version('broom', version = '1.0.5', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('repr', version = '1.1.6', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('infer', version = '1.0.4', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('gridExtra', version = '2.3', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('faraway', version = '1.0.8', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('mitools', version = '2.4', repos = 'https://cloud.r-project.org')"  # Updated version
RUN Rscript -e "remotes::install_version('glmnet', version = '4.1.7', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('cowplot', version = '1.1.2', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('modelr', version = '0.1.11', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('ggplot2', version = '3.4.3', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('dplyr', version = '1.1.3', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('patchwork', version = '1.2.0', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('knitr', version = '1.42', repos = 'https://cloud.r-project.org')"

# Expose port 8787 for RStudio
EXPOSE 8787

# Start RStudio
CMD ["/init"]