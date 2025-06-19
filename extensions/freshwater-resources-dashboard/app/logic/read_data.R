box::use(
  dplyr[arrange, filter, left_join, pull],
  here[here],
  magrittr[`%>%`],
  qs[qread],
  sf[st_read],
  stats[setNames],
  utils[head],
)

#' @export
complete_data <- qread(
  here("app/data/complete_data.qs")
)

#' @export
map_data <- st_read(
  dsn = here("app/data/map_data.shp"),
  quiet = TRUE
)

#' @export
map_indicator <- "Total population with access to safe drinking-water (JMP) (%)"

#' @export
trend_raw <- qread(here("app/data/data_trendline.qs")) |>
  left_join(
    qread(here("app/data/continent_mapping.qs")),
    by = "Country"
  )

#' @export
read_qs <- function(path) {
  temp_df <- qread(
    here(path)
  )
  return(temp_df)
}

#' @export
get_top5_countries <- function(df, continent,
                               indicator =
                                 "Total renewable water resources per capita (m3/inhab/year)") {
  all_counties <- sort(unique(df$Country))

  top5_countries <- df %>%
    filter(
      Year == 2020,
      Continent == continent
    ) %>%
    arrange(desc(.[[which(names(df) == indicator)]])) %>%
    head(5) |>
    pull(Country)

  return(list(top5_countries = top5_countries))
}

#' @export
color_set <- c(
  "#0099F9", "#FA7C2E", "#00E255",
  "#FB4157", "#FAE22D", "#00B49E",
  "#843BFA", "#4357FB"
)
