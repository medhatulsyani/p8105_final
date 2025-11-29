## make_clean_data.R
library(tidyverse)
library(janitor)
library(stringr)

# ---- 1. Import raw datasets ----

zip_path <- "./data/Automated_Traffic_Volume_Counts.zip"
csv_filename_in_zip <- "Automated_Traffic_Volume_Counts.csv"

traffic_volume_df <- read_csv(
  unz(description = zip_path, filename = csv_filename_in_zip)
)

aed_inventory_df <- read_csv(
  "./data/NYC_Automated_External_Defibrillator_(AED)_Inventory.csv"
)

leading_causes_df <- read_csv(
  "./data/NYC_Leading_Causes_of_Death.csv"
)

# ---- 2. Clean traffic data ----
traffic_clean <- traffic_volume_df |>
  clean_names() |>
  filter(yr >= 2019 & yr <= 2024) |>
  mutate(boro = str_to_title(boro))

# Save cleaned traffic data
write_csv(traffic_clean, "data/traffic_clean.csv")

# ---- 3. Clean AED data ----
aed_clean <- aed_inventory_df |>
  clean_names() |>
  filter(!is.na(latitude), !is.na(longitude)) |>
  mutate(borough = str_to_title(borough))

# Save cleaned AED data
write_csv(aed_clean, "data/aed_clean.csv")

# ---- 4. Clean leading causes of death data ----
leading_clean <- leading_causes_df |>
  clean_names() |>
  mutate(
    deaths = as.numeric(deaths),
    death_rate = as.numeric(death_rate),
    age_adjusted_death_rate = as.numeric(age_adjusted_death_rate)
  )

# Save cleaned causes of death data
write_csv(leading_clean, "data/leading_causes_clean.csv")

