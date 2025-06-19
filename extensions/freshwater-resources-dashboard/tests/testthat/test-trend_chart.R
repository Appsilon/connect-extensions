box::use(
  dplyr[n_distinct],
  testthat[...],
  tibble[tibble],
)

box::use(
  app/logic/trend_chart[trend_data_process],
)

# Test cases for trend_data_process
test_that("trend_data_process returns the correct output", {
  raw_data_4_test <- tibble(
    Country = c("USA", "USA", "USA"),
    Year = c(2020, 2021, 2022),
    "Total renewable water resources per capita (m3/inhab/year)" =
      c(100, 200, 300),
    "Total renewable water resources (10^9 m3/year)" = c(1, 2, 3)
  )
  raw_data2_4_test <- tibble(
    Country = c(
      "USA", "Canada", "Mexico",
      "India", "Russia", "China"
    ),
    Year = c(2020, 2020, 2020, 2020, 2020, 2020),
    "Total renewable water resources per capita (m3/inhab/year)" = c(100, 200, 300, 400, 500, 600),
    "Total renewable water resources (10^9 m3/year)" =
      c(1, 2, 3, 4, 5, 6)
  )

  # Test case 1: Test if the function returns the expected number of rows
  processed_data <- trend_data_process(raw_data_4_test, country_selection = "USA")
  expect_equal(nrow(processed_data), 3)

  # Test case 2: Test if the function returns the expected column names
  expected_colnames <- c("Country", "Year", "indicator", "unit", "comment")
  processed_data <- trend_data_process(raw_data_4_test, country_selection = "USA")
  expect_equal(colnames(processed_data), expected_colnames)

  # Test case 3: Test if the function correctly assigns comments
  expected_comment <- c(
    "<i>Origination year</i>",
    "<i>100% increase from previous year</i>",
    "<i>50% increase from previous year</i>"
  )
  processed_data <- trend_data_process(
    raw_data = raw_data_4_test,
    country_selection = "USA"
  )
  expect_equal(processed_data$comment, expected_comment)

  # Test case 4: Test if the function returns max 5 countires if country_selection is NA
  processed_data <- trend_data_process(
    raw_data = raw_data2_4_test,
    country_selection = NA
  )
  expect_lte(n_distinct(processed_data$Country), 5)
})
