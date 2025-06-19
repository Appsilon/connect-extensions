box::use(
  dplyr[arrange, case_when, filter, group_by, lag, mutate, pull, select],
  echarts4r[...],
  here[here],
  htmlwidgets[JS],
  magrittr[`%>%`],
  qs[qread],
  stringr[str_detect],
  utils[head],
)

#' @description The following function takes raw data and indicator
#' type as argument and returns the processed data for trend_chart function
#' @param raw_data raw data from qs file
#' @country_selection country selected by user
#' @param indicator Indicator to plot
#' Can be 'Total renewable water resources
#' or 'Total renewable water resources per capita'
#' @return processed & filtered dataframe
#' @export
trend_data_process <- function(raw_data,
                               country_selection,
                               indicator =
                                 "Total renewable water resources per capita (m3/inhab/year)") {
  # indicator param cleaning
  if (str_detect(indicator, "per capita")) {
    indicator <- "Total renewable water resources per capita (m3/inhab/year)"
    unit <- paste0("' m' + '<sup>3 </sup>'
                   +'/inhab/year'")
  } else {
    indicator <- "Total population with access to safe drinking-water (JMP) (%)"
    unit <- paste0("' %'")
  }

  # below code is for testing only
  if (all(is.na(country_selection))) {
    country_selection <- raw_data %>%
      filter(Year == 2020) %>%
      arrange(desc(.[[which(names(raw_data) == indicator)]])) %>%
      head(5) |>
      pull(Country)
  }

  # data processing
  raw_data <- raw_data |>
    select(Country, Year, "indicator" = indicator) |>
    filter(Country %in% country_selection)

  if (any(is.na(raw_data$indicator))) {
    raw_data <- raw_data |>
      filter(!is.na(indicator))
  }

  raw_data <- raw_data |>
    mutate(
      Year = as.character(Year),
      indicator = round(indicator),
      unit = unit
    ) |>
    group_by(Country) |>
    arrange(Year) |>
    mutate(
      deviation = round((indicator - lag(indicator)) / lag(indicator), 3) * 100,
      comment = case_when(
        deviation == 0 ~ "<i>No movement from previous year</i>",
        is.na(deviation) ~ "<i>Origination year</i>",
        TRUE ~ paste0(
          "<i>",
          abs(deviation), "%",
          ifelse(deviation < 0,
            " drop",
            " increase"
          ),
          " from previous year</i>"
        )
      )
    ) |>
    select(-deviation)

  return(raw_data)
}

#' @description The following function takes processed data and indicator
#' type as argument and returns a line chart object
#' @param base_data processed data
#' @param color_palette custom color palette, used when use_json_theme = FALSE
#' @param use_json_theme boolean flag for usage of custom json theme
#' @param json_theme_path path for json file
#' Can be 'Total renewable water resources
#' or 'Total renewable water resources per capita'
#' @return echart object to be used in shiny module
#' @export
trend_echart <- function(base_data,
                         color_palette = c(
                           "#005067", "#048329", "#f7d6bf",
                           "#FEB9C6", "#B96B85"
                         ),
                         use_json_theme = TRUE,
                         json_theme_path = paste0(here("app/json/appsilon.echarts.json")),
                         indicator_title) {
  unit_tooltip <- unique(base_data$unit)
  stopifnot(length(unit_tooltip) == 1)

  trend_tooltip_format <- paste0(
    "function(params){
                var vals = params.name.split(',')

                return('<strong>' +
                       params.seriesName +' - ' + params.value[0] +
                       '</strong><br />' +
                       Number(params.value[1]).toLocaleString('en-US') + ", unit_tooltip,
    "+ '<br />' + vals[0])   }  "
  )

  if (str_detect(indicator_title, "%")) {
    y_axis_label_format <- JS(
      "function(value) {",
      "  return (value) + '%';",
      "}"
    )
  } else {
    y_axis_label_format <- JS(
      "function(value) {",
      "  return (value / 1000) + 'K';",
      "}"
    )
  }

  line_chart <- base_data |>
    e_charts(x = Year) |>
    e_line(
      serie = indicator,
      showSymbol = FALSE,
      smooth = TRUE,
      bind = comment,
      animationDuration = 3000,
      animationEasing = "circularInOut",
      lineStyle = list(width = 3)
    ) |>
    e_legend(
      orient = "vertical",
      top = "center",
      right = 10
    ) |>
    e_x_axis(axisLabel = list(
      fontStyle = "normal",
      fontFamily = "Maven Pro",
      fontWeight = 400,
      fontSize = "12px"
    )) |>
    e_y_axis(
      scale = TRUE,
      axisLabel = list(
        formatter = y_axis_label_format,
        fontStyle = "normal",
        fontFamily = "Maven Pro",
        fontWeight = 400,
        fontSize = "12px"
      )
    ) %>%
    # Add Icon of flag - todo
    # check flag avaialility for every country in dataset
    # and have a default flag in case of missing

    {
      if (use_json_theme) {
        e_theme_custom(., theme = json_theme_path)
      } else {
        e_color(., color = color_palette)
      }
    } |>
    e_title(
      text = indicator_title,
      x = "center",
      textStyle = list(
        fontStyle = "normal",
        fontFamily = "Maven Pro",
        fontWeight = 400,
        fontSize = "14px"
      )
    ) |>
    e_tooltip(
      formatter = e_tooltip_pointer_formatter("decimal"),
      trigger = "axis",
      borderWidth = 1,
      triggerOn = "mousemove|click",
      showDelay = 20,
      textStyle = list(
        fontStyle = "normal",
        fontFamily = "Maven Pro",
        fontWeight = 500,
        fontSize = "16px"
      ),
      enterable = FALSE,
      extraCssText = "box-shadow: 0 2px 7px #000000;"
    ) |>
    e_hide_grid_lines(which = c("x", "y")) |>
    e_datazoom() |>
    e_zoom(
      dataZoomIndex = 0
    )

  return(line_chart)
}
