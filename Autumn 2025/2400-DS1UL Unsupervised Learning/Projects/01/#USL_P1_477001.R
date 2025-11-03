################################################################################
#########################  Ondřej Marvan #######################################
########################## USL 2025/2026 #######################################
############################ Project 1 #########################################
################################################################################


Sys.setlocale("LC_ALL","English")
Sys.setenv(LANGUAGE='en')

# --- 1. Load Libraries and Data
Library(tidyverse)

# Load the pre-processed and pivoted data
clustering_data_raw <- read_csv("world_energy_shares_pivot.csv")

# --- 2. Prepare Data for Clustering ---
