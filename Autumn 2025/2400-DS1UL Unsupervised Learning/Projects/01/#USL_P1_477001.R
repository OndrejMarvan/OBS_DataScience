################################################################################
#########################  Ondřej Marvan #######################################
########################## USL 2025/2026 #######################################
############################ Project 1 #########################################
################################################################################


Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

install.packages("tidyverse")


# Load the libraries
library(tidyverse)
library(jsonlite)

# --- 2. Define Data Sources ---

# Source 1: The main energy data
data_url <- "https://ourworldindata.org/grapher/per-capita-energy-stacked.csv?v=1&csvType=full&useColumnShortNames=true"

# Source 2: The metadata (helpful for understanding column definitions)
meta_url <- "https://ourworldindata.org/grapher/per-capita-energy-stacked.metadata.json?v=1&csvType=full&useColumnShortNames=true"

# --- 3. Fetch Data ---

# Use readr::read_csv() (from tidyverse) - it's fast and smart
energy_data_raw <- read_csv(data_url)

# Fetch the metadata using jsonlite::fromJSON()
metadata <- fromJSON(meta_url)

# --- 4. Initial Inspection ---

cat("\n--- Structure of the Raw Energy Data ---\n")
# Print a summary to confirm data types and column names
energy_data_raw