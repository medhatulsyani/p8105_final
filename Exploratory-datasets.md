AED Accessibility and Traffic in NYC: Exploratory Data
================

**Library**

``` r
library(tidyverse)
library(janitor)
library(stringr)
```

**Import data**

``` r
zip_path = "./data/Automated_Traffic_Volume_Counts.zip"
csv_filename_in_zip = "Automated_Traffic_Volume_Counts.csv"
traffic_volume_df = read_csv(unz(description = zip_path, filename = csv_filename_in_zip))


aed_inventory_df = read_csv("./data/NYC_Automated_External_Defibrillator_(AED)_Inventory.csv")
leading_causes_df = read_csv("./data/NYC_Leading_Causes_of_Death.csv")

traffic_volume_df |> glimpse()
```

    ## Rows: 1,838,386
    ## Columns: 14
    ## $ RequestID <dbl> 22562, 22562, 22562, 22562, 22562, 22562, 22562, 22562, 2256…
    ## $ Boro      <chr> "Queens", "Queens", "Queens", "Queens", "Queens", "Queens", …
    ## $ Yr        <dbl> 2016, 2016, 2016, 2016, 2016, 2016, 2016, 2016, 2016, 2016, …
    ## $ M         <dbl> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, …
    ## $ D         <dbl> 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, …
    ## $ HH        <dbl> 8, 9, 9, 9, 9, 10, 10, 10, 10, 11, 11, 11, 11, 12, 12, 12, 1…
    ## $ MM        <dbl> 45, 0, 15, 30, 45, 0, 15, 30, 45, 0, 15, 30, 45, 0, 15, 30, …
    ## $ Vol       <dbl> 260, 243, 245, 304, 312, 331, 331, 344, 397, 356, 394, 399, …
    ## $ SegmentID <dbl> 155613, 155613, 155613, 155613, 155613, 155613, 155613, 1556…
    ## $ WktGeom   <chr> "POINT (1059678.8154876027 198480.09766927382)", "POINT (105…
    ## $ street    <chr> "HEMPSTEAD AVENUE", "HEMPSTEAD AVENUE", "HEMPSTEAD AVENUE", …
    ## $ fromSt    <chr> "Cross Island Parkway", "Cross Island Parkway", "Cross Islan…
    ## $ toSt      <chr> "Cross Is Pkwy Nb En Hempstead Wb", "Cross Is Pkwy Nb En Hem…
    ## $ Direction <chr> "WB", "WB", "WB", "WB", "WB", "WB", "WB", "WB", "WB", "WB", …

``` r
aed_inventory_df  |> glimpse()
```

    ## Rows: 7,642
    ## Columns: 17
    ## $ Entity_Name          <chr> "CFN DAP", "Olmstead Condominium", "Citywide", "M…
    ## $ Address              <chr> "1 FORDHAM PLAZA", "382 CENTRAL PARK WEST", "63 F…
    ## $ Floor                <chr> "7th Floor", "Gym", NA, "-", "Ground", NA, "331",…
    ## $ Borough              <chr> "Bronx", "Manhattan", "Brooklyn", "Manhattan", "M…
    ## $ State                <chr> "New York", "New York", "New York", "New York", "…
    ## $ Zip                  <chr> "10458", "10001", "11205", "10001", "10065", "100…
    ## $ AED_NumPersonTrained <dbl> 4, 17, 0, 38, 12, 19, 20, 3, 7, 4, 1, 12, 2, 9, 2…
    ## $ AED_NumAeds          <dbl> 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
    ## $ Latitude             <dbl> 40.86073, 40.79347, 40.69801, 40.74773, 40.76459,…
    ## $ Longitude            <dbl> -73.88958, -73.96567, -73.97499, -73.99672, -73.9…
    ## $ Community_District   <dbl> 206, 107, 302, 104, 108, 107, 204, 105, 108, 105,…
    ## $ Council_District     <dbl> 15, 7, 33, 3, 4, 6, 16, 6, 4, 4, 3, 34, 13, 42, 1…
    ## $ Census_Tract_2010    <dbl> 38700, 18500, 54300, 9700, 11402, 14500, 18900, 1…
    ## $ NTA_Code             <chr> "BX06", "MN12", "BK99", "MN13", "MN40", "MN14", "…
    ## $ BBL                  <dbl> 2030330053, 1018337501, 3020230001, 1007510001, 1…
    ## $ BIN                  <dbl> 2088325, 1074358, 3000000, 1082793, 1042055, 1076…
    ## $ `Location Point`     <chr> "POINT (-73.88958427 40.86073227)", "POINT (-73.9…

``` r
leading_causes_df |> glimpse()
```

    ## Rows: 2,102
    ## Columns: 7
    ## $ Year                      <dbl> 2021, 2021, 2021, 2021, 2021, 2021, 2021, 20…
    ## $ `Leading Cause`           <chr> "Diseases of Heart (I00-I09, I11, I13, I20-I…
    ## $ Sex                       <chr> "Male", "Female", "Female", "Male", "Male", …
    ## $ `Race Ethnicity`          <chr> "Not Stated/Unknown", "Not Stated/Unknown", …
    ## $ Deaths                    <chr> "190", "7", "113", "84", "11", "14", "66", "…
    ## $ `Death Rate`              <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
    ## $ `Age Adjusted Death Rate` <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …

**Clean data**

``` r
traffic_clean = traffic_volume_df |>
  clean_names() |>
  filter(yr >= 2019, yr <= 2024) |>
  mutate(boro = str_to_title(boro))

aed_clean = aed_inventory_df |>
  clean_names() |>
  filter(!is.na(latitude), !is.na(longitude)) |>
  mutate(borough = str_to_title(borough))

leading_clean = leading_causes_df |>
  clean_names() |>
  mutate(
  deaths = as.numeric(deaths),
  death_rate = as.numeric(death_rate),
  age_adjusted_death_rate = as.numeric(age_adjusted_death_rate)
  )
```

    ## Warning: There were 3 warnings in `mutate()`.
    ## The first warning was:
    ## ℹ In argument: `deaths = as.numeric(deaths)`.
    ## Caused by warning:
    ## ! NAs introduced by coercion
    ## ℹ Run `dplyr::last_dplyr_warnings()` to see the 2 remaining warnings.

### Summarize table

**Leading Causes of Death Summary by year**

``` r
# Create a clean disease name without ICD codes
leading_clean2 = leading_clean |>
  mutate(
    cause_name = str_replace(leading_cause, " \\(.*\\)$", "")
  )

# Summarise total deaths by disease name for 2021
death_baseline = leading_clean2 |>
  filter(year == 2021) |>
  group_by(cause_name) |>
  summarise(
    total_deaths = sum(deaths, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(total_deaths))

knitr::kable(
  death_baseline,
  caption = "Table 1: Leading causes of death in NYC, 2021 (disease names only)"
)
```

| cause_name | total_deaths |
|:---|---:|
| Diseases of Heart | 16568 |
| All Other Causes | 14240 |
| Malignant Neoplasms | 11578 |
| Covid-19 | 8229 |
| Mental and Behavioral Disorders due to Accidental Poisoning and Other Psychoactive Substance Use | 2692 |
| Cerebrovascular Disease | 2149 |
| Influenza | 1628 |
| Diabetes Mellitus | 1535 |
| Chronic Lower Respiratory Diseases | 1212 |
| Essential Hypertension and Renal Diseases | 1150 |
| Accidents Except Drug Poisoning | 1112 |
| Alzheimer’s Disease | 822 |
| Assault | 291 |
| Chronic Liver Disease and Cirrhosis | 188 |
| Intentional Self-Harm | 79 |
| Chronic Liver Diseases and Cirrhosis | 25 |
| Septicemia | 24 |
| Mental and Behavioral Disorders due to Use of Alcohol | 16 |
| Certain Conditions Originating in the Perinatal Period | 15 |
| Human Immunodeficiency Viruses Diseases | 7 |

Table 1: Leading causes of death in NYC, 2021 (disease names only)

**Top 1: Diseases of Heart** —\> the importance of having AED

### Main analysis summary

**Traffic volume summary by borough**

``` r
traffic_summary = traffic_clean |>
  group_by(boro) |>
  summarise(
    n_measurements = n(),
    unique_segments = n_distinct(segment_id),
    mean_volume = mean(vol, na.rm = TRUE),
    median_volume = median(vol, na.rm = TRUE)
  ) |>
rename(borough = boro)

knitr::kable(
  traffic_summary,
  caption = "Table 2: Traffic volume summary by borough (2019–2024)"
)
```

| borough       | n_measurements | unique_segments | mean_volume | median_volume |
|:--------------|---------------:|----------------:|------------:|--------------:|
| Bronx         |          64572 |              88 |    86.53117 |            55 |
| Brooklyn      |         160661 |             221 |   122.67490 |            61 |
| Manhattan     |          88011 |             115 |   147.59724 |            93 |
| Queens        |         162987 |             186 |   117.74871 |            57 |
| Staten Island |          24494 |              33 |   108.96228 |            67 |

Table 2: Traffic volume summary by borough (2019–2024)

**AED inventory summary by borough**

``` r
aed_summary = aed_clean |>
  group_by(borough) |>
  summarise(
    aed_locations = n(),
    mean_num_aeds = mean(aed_num_aeds, na.rm = TRUE),
    mean_trained  = mean(aed_num_person_trained, na.rm = TRUE)
  )

knitr::kable(
  aed_summary,
  caption = "Table 3: AED inventory summary by borough"
)
```

| borough       | aed_locations | mean_num_aeds | mean_trained |
|:--------------|--------------:|--------------:|-------------:|
| Bronx         |           988 |      1.042510 |     9.966599 |
| Brooklyn      |          1411 |      1.102764 |    10.819149 |
| Manhattan     |          3667 |      1.795200 |    17.464773 |
| Queens        |          1228 |      1.478013 |    17.363115 |
| Staten Island |           345 |      1.228986 |    16.597101 |

Table 3: AED inventory summary by borough

``` r
baseline_table = left_join(aed_summary, traffic_summary, by = "borough")

knitr::kable(
  baseline_table,
  caption = "Table 4: Baseline summary of AED and traffic characteristics by borough"
)
```

| borough | aed_locations | mean_num_aeds | mean_trained | n_measurements | unique_segments | mean_volume | median_volume |
|:---|---:|---:|---:|---:|---:|---:|---:|
| Bronx | 988 | 1.042510 | 9.966599 | 64572 | 88 | 86.53117 | 55 |
| Brooklyn | 1411 | 1.102764 | 10.819149 | 160661 | 221 | 122.67490 | 61 |
| Manhattan | 3667 | 1.795200 | 17.464773 | 88011 | 115 | 147.59724 | 93 |
| Queens | 1228 | 1.478013 | 17.363115 | 162987 | 186 | 117.74871 | 57 |
| Staten Island | 345 | 1.228986 | 16.597101 | 24494 | 33 | 108.96228 | 67 |

Table 4: Baseline summary of AED and traffic characteristics by borough
