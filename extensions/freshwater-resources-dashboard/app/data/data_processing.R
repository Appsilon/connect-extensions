box::use(
  dplyr[...],
  qs[...],
  tidyr[...],
)

# Reading the original dataset extracted from Aquastat (all variables included)

all_variables_dataset <- qread("app/data/all_variables_dataset.qs")

# Unify country names with the ones in map file

all_variables_dataset <- all_variables_dataset |>
  mutate(
    Country = case_when(
      Country == "Bolivia (Plurinational State of)" ~ "Bolivia",
      Country == "Democratic Republic of the Congo" ~ "Congo DRC",
      Country == "Czechia" ~ "Czech Republic",
      Country == "Democratic People's Republic of Korea" ~ "North Korea",
      Country == "Iran (Islamic Republic of)" ~ "Iran",
      Country == "Lao People's Democratic Republic" ~ "Laos",
      Country == "Micronesia (Federated States of)" ~ "Micronesia",
      Country == "Republic of Moldova" ~ "Moldova",
      Country == "Republic of Korea" ~ "South Korea",
      Country == "Netherlands (Kingdom of the)" ~ "Netherlands",
      Country == "Palestine" ~ "Palestinian Territory",
      Country == "Syrian Arab Republic" ~ "Syria",
      Country == "United Kingdom of Great Britain and Northern Ireland" ~ "United Kingdom",
      Country == "United Republic of Tanzania" ~ "Tanzania",
      Country == "United States of America" ~ "United States",
      Country == "Venezuela (Bolivarian Republic of)" ~ "Venezuela",
      Country == "Viet Nam" ~ "Vietnam",
      Country == "Türkiye" ~ "Turkiye",
      TRUE ~ Country
    )
  )



variables_to_keep <- c(
  "Total renewable water resources per capita",
  "Total population with access to safe drinking-water (JMP)"
)

# Transforming data to the required format
# where two selected variables get their own columns
# renamed columns to display their unit of measurement

selected_variables_dataset <- all_variables_dataset |>
  filter(Variable %in% variables_to_keep) |>
  pivot_wider(
    id_cols = c("Country", "Year"),
    names_from = "Variable",
    values_from = "Value"
  ) |>
  rename(
    `Total renewable water resources per capita (m3/inhab/year)` =
      `Total renewable water resources per capita`,
    `Total population with access to safe drinking-water (JMP) (%)` =
      `Total population with access to safe drinking-water (JMP)`
  )

# Keep latest year data to be used on the map plot

data_map <- selected_variables_dataset |>
  filter(Year == 2020)

# Saving data to be used in the map in a qs file
qsave(data_map, "app/data/data_map.qs")

# Saving data to be used in the trendline graph in a qs file

qsave(selected_variables_dataset, "app/data/data_trendline.qs")
