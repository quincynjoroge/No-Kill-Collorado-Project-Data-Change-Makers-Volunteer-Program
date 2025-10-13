## Data Transformation Script ==================================================
##
## Transform -------------------------------------------------
##
## This script focuses on transforming the cleaned data into analysis-ready formats. 
## It includes tasks such as reshaping datasets, creating derived variables, 
## aggregating metrics, standardizing categorical values, and preparing summary 
## tables to support multi-year trend analysis and visualization.

#### 0.0  Load functions -------
install.packages("tidyverse")
install.packages("janitor")
install.packages("feather")
install.packages("googledrive")
install.packages("here")
install.packages("gt")


library(tidyverse)
library(dplyr)
library(janitor)
library(gt)
library(feather)
library(googledrive) 
library(readr)
library(readxl)

#### 1.0 Load data -------
df0 <- read_excel("/Users/quunc/Downloads/NKC_data.xlsx")

#### Transform 1 --------

# Create summary variables for key outcomes:
# - 'total_intake': sum of all intake categories for each organization, regardless of source.
# - 'total_adoption': total number of adoptions recorded.
# - 'total_death': total number of deaths recorded.
# These variables provide a consolidated view of each organization's intake and outcome statistics.

df1 <- df0 %>%
  mutate(total_intake = rowSums(across(starts_with("intake_")), na.rm = TRUE),
         total_adoption = outcome_adoption,
         total_death = outcome_deaths )

#### Transform 2 --------

# Create 'Negative_Outcomes' summary variable:
# - 'Negative_Outcomes': total number of animals that did not leave the shelter alive,
#   including euthanasia, deaths, and missing outcomes.
# These variables will be used to compare transfer trends with negative outcomes over time.

df1 <- df1 %>%
  mutate(negative_outcomes = outcome_euthanasia + outcome_deaths + outcome_missing_or_stolen)



#### Export feather file --------
write_feather(df1, "data/data_transformed/nkc.feather")
