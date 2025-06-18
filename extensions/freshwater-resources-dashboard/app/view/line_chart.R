box::use(
  dplyr[filter,
        group_by,
        distinct,
        arrange, `%>%`],
  shiny[moduleServer,
        tagList,
        reactive,
        NS,
        div,
        column,
        # selectizeInput, updateSelectizeInput,
        fluidRow,
        observeEvent,
        absolutePanel,
        icon
        ],
  shinyWidgets[dropdown,
               animations,
               animateOptions,
               tooltipOptions,
               pickerInput,
               updatePickerInput],
  tibble[rownames_to_column],
  echarts4r[renderEcharts4r,
            echarts4rOutput,
            e_charts,
            e_line,
            e_x_axis],
  htmltools[h4, p, tags],
  shinycssloaders[withSpinner],
)

box::use(app / logic / read_data [trend_raw,
                                  get_top5_countries,
                                  color_set],
         app / logic / trend_chart)


#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    fluidRow(
      div(
        id = "country_sel_div",
        class = "font_decor_class",

        absolutePanel(
          left      = 120,
          bottom    = 100,
          top       = 520,
          right     = "auto",
          draggable = TRUE,
          cursor    = c("auto"),
          style     = "opacity: 0.95; z-index: 10;",

          # dropdown button ----
          dropdown(
            tooltip = tooltipOptions(title = "Filters"),
            style   = "unite",
            icon    = icon("gear"),
            status  = "primary",
            size    = "md",
            animate = animateOptions(
              enter = animations$fading_entrances$fadeIn,
              exit  = animations$fading_exits$fadeOut),

            # Continent Selector ----
            pickerInput(
              inputId = ns("continent_sel_id"),
              label = "Continent",
              choices = sort(unique(trend_raw$Continent)),
              selected = "North America",
              multiple = FALSE,
              inline = TRUE),

            # Country Selector ----
            pickerInput(
              inputId = ns("country_sel_id"),
              label = "Country",
              choices = trend_raw |>
                distinct(Continent, Country) |>
                arrange(Continent, Country) %>%
                split(x = .$Country, f = .$Continent),
              selected = get_top5_countries(
                df = trend_raw,
                continent = "North America")$top5_countries,
              multiple = TRUE,
              inline = TRUE,
              options = list(
                `live-search`             = TRUE,
                `size`                    = 8,
                `selected-text-format`    = "count > 5",
                `width`                   = "300px",
                `max-options`             = 8,
                `live-search-placeholder` = "Search your country :)",
                `max-options-text`        = "Country selection limit reached",
                `none-results-text`       = "Whoops, country not found!",
                `none-selected-text`      = "Showing top 5 countries (per capita indicator)")
              ),
          )
        )
      )
    ),
    fluidRow(
      column(
        width = 6,
        div(
          class = "box_decor_class",
          withSpinner(
            echarts4rOutput(
            outputId = ns("per_capita_output")),
            type = 4,
            size = 0.5,
            color = "#0099f9"))
      ),
      column(
        width = 6,
        div(
          class = "box_decor_class",
          withSpinner(
            echarts4rOutput(
            outputId =   ns("perc_available_output")),
            type = 4,
            size = 0.5,
            color = "#0099f9"))
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Observing input change of continent and changing countires----
      observeEvent(input$continent_sel_id, {
        updatePickerInput(
          session,
          inputId = "country_sel_id",
          selected = get_top5_countries(trend_raw,
                                        continent = input$continent_sel_id)$top5_countries,
        )
      },
      ignoreInit = TRUE)

    # Chart reactive ----
    line_chart_reactive <- reactive({

      country_sel <- input$country_sel_id

      clean_data_percap <-
        trend_chart$trend_data_process(
          raw_data = trend_raw,
          country_selection = country_sel,
          indicator =
            "Total renewable water resources per capita (m3/inhab/year)"
        )
      clean_data_perc <-
        trend_chart$trend_data_process(
          raw_data = trend_raw,
          country_selection = country_sel,
          indicator =
            "Total population with access to safe drinking-water (JMP) (%)"
        )

      return(list(clean_data_percap = clean_data_percap,
                  clean_data_perc = clean_data_perc))
    })

    # Plotting chart 1 ----
    output$per_capita_output <- renderEcharts4r({
      clean_data <- line_chart_reactive()$clean_data_percap
      trend_chart$trend_echart(
        base_data = clean_data,
        use_json_theme = FALSE,
        color_palette = color_set,
        indicator_title =
          "Renewable water resources per capita \n (m3/inhab/year)")
    })

    # Plotting chart 2 ----
    output$perc_available_output <- renderEcharts4r({
      clean_data <- line_chart_reactive()$clean_data_perc
      trend_chart$trend_echart(
        base_data = clean_data,
        use_json_theme = FALSE,
        color_palette = color_set,
        indicator_title =
          "Population with access to safe drinking-water \n (%)")
    })
  })
}
