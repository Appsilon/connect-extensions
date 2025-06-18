box::use(
  shiny[...],
  leaflet[...],
  dplyr[
    case_when,
    select,
    mutate,
    group_by,
    filter,
    arrange,
    pull,
    left_join,
    join_by,
  ],
  tidyr[replace_na],
  htmlwidgets[JS],
  htmltools[HTML],
  glue[glue],
  shinycssloaders[withSpinner],
  leaflet.extras[...]
)

box::use(
  app/logic/read_data[map_data, map_indicator]
)

tooltip_html_text <- file.info("app/html/tooltip.html")
tooltip_html_text <- readChar(rownames(tooltip_html_text), nchars = tooltip_html_text$size)

variables_to_choose <- c(
  "Renewable water resources per capita" =
    "Total renewable water resources per capita (m3/inhab/year)",
  "Access to safe drinking-water" =
    "Total population with access to safe drinking-water (JMP) (%)")


#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    absolutePanel(
      div(
        class = "indicator_choice",
        radioButtons(
          ns("indicatorVar"),
          label = NULL,
          choices = variables_to_choose,
          selected = variables_to_choose[1]
        )
      ),
      draggable = TRUE
    ),
    div(
      class = "box_decor_class",
      withSpinner(leafletOutput(ns("map")),
        type = 4,
        size = 0.7,
        color = "#0099f9"
      )
    )
  )
}

#' @export
server <- function(id, base_df) {
  moduleServer(id, function(input, output, session) {

    filtered_map_df <- reactive({
      base_df |> select(Country, "indicator" = input$indicatorVar)
    })

    breaks <- reactive({
      if (input$indicatorVar == variables_to_choose[1]) {

        indicator_max_value <- filtered_map_df()$indicator |> max(na.rm = TRUE)

        return(c(0, 1000, 3000, 5000, 10000, 100000, round(indicator_max_value, digits = -5)))

      } else {
        return(c(30, 50, 60, 80, 95, 100))
      }
    })


    qpal <- reactive({
      colorBin("RdYlBu", domain = map_df()$bins, bins = breaks(), na.color = NA)
    })

    map_df <- reactive({
      if (input$indicatorVar == variables_to_choose[2]) {
        lev1 <- 50
        lev2 <- 80
      } else {
        lev1 <- 3000
        lev2 <- 5000
      }
      joined_map_data <- map_data |>
        left_join(
          filtered_map_df(),
          by = join_by(COUNTRY == Country)
        ) |>
        replace_na(
          list(
            indicator = 0
          )
        ) |>
        mutate(
          indicator = floor(indicator),
          bg_color = case_when(
            indicator <= lev1 ~ "font_clr_bad",
            (indicator > lev1) & (indicator < lev2) ~ "font_clr_avg",
            indicator >= lev2 ~ "font_clr_good"
          )
        )

      joined_map_data$interval <- findInterval(joined_map_data$indicator, breaks())
      joined_map_data$bins <- breaks()[joined_map_data$interval + 1]

      return(joined_map_data)
    })

    popup_template <- reactive({
      if (input$indicatorVar == variables_to_choose[1]) {
        lapply(
          X = sprintf(
            fmt = tooltip_html_text,
            map_df()$bg_color,
            map_df()$COUNTRY,
            map_df()$indicator,
            "m3/inhab/year",
            "Renewable water resources per capita"
          ),
          FUN = HTML
        )
      } else {
        lapply(
          X = sprintf(
            fmt = tooltip_html_text,
            map_df()$bg_color,
            map_df()$COUNTRY,
            map_df()$indicator,
            "%",
            "Population with access to safe drinking-water"
          ),
          FUN = HTML
        )
      }

    })

    output$map <- renderLeaflet({
      map_df() |>
        leaflet(
          options = leafletOptions(
            attributionControl = FALSE,
            worldCopyJump = TRUE
          )
        ) |>
        setView(
          lng = 31,
          lat = 30,
          zoom = 3
        ) |>
        addTiles(group = "OSM",
                 options = providerTileOptions(minZoom = 3,
                                               maxZoom = 7)) |>
        addProviderTiles("Stadia.StamenToner",
                         group = "Toner",
        options = providerTileOptions(minZoom = 3,
                                      maxZoom = 7)) |>
        addProviderTiles("Esri.WorldImagery",
                         group = "Satellite",
                         options = providerTileOptions(minZoom = 3,
                                                       maxZoom = 7)) |>
        addProviderTiles("Stadia.StamenTonerLite",
                         group = "Toner Lite",
                         options = providerTileOptions(minZoom = 3,
                                                       maxZoom = 10)) |>
        addPolygons(
          layerId = ~COUNTRY,
          color = "black",
          fillColor = ~ qpal()(indicator),
          dashArray = "1",
          weight = 1,
          group = "Total Water Resources",
          smoothFactor = 1,
          fillOpacity = 0.5,
          highlightOptions = highlightOptions(
            color = "black",
            weight = 2,
            dashArray = "",
            fillOpacity = 0.1,
            bringToFront = FALSE
          ),
          label = ~ popup_template(),
          labelOptions = labelOptions(
            direction = "auto",
            textOnly = FALSE,
            opacity = 0.8,
            className = "renewflow_label"
          )
        ) |>
        addLayersControl(
          baseGroups = c("OSM", "Satellite", "Toner", "Toner Lite"),
          options = layersControlOptions(collapsed = TRUE)
        ) |>
        addLegend(
          pal = qpal(),
          title = input$indicatorVar,
          values = ~indicator,
          opacity = 1,
          na.label = "",
          position = c("bottomright")
        ) |>
        addFullscreenControl(position = "topleft", pseudoFullscreen = FALSE)
    })

    observe({
      click <- input$map_shape_click
      if (is.null(click)) {
        return()
      } else {
        country <- input$map_shape_click$id
        country_info <- filtered_map_df() |>
          filter(filtered_map_df()$Country == as.character(country))
        if (length(country_info$Country == "") == 0) {
          map_text_output <- glue("<b> Data not found !</b><br>")
        } else {
          indicator_val <- ifelse(is.na(country_info$indicator), 0, country_info$indicator)
          map_text_output <- glue(
            "<b>{country_info$Country} </b><br>
                            {input$indicatorVar} : {round(indicator_val, 2)}<br>"
          )
        }
        cordinates <- map_data |>
          filter(map_data$COUNTRY == as.character(country))
        leafletProxy("map") %>%
          setView(
            lng = cordinates$cnt_LON,
            lat = cordinates$cnt_LAT,
            zoom = 5
          ) %>%
          clearMarkers() %>%
          addMarkers(
            lng = cordinates$cnt_LON,
            lat = cordinates$cnt_LAT,
            popup = map_text_output
          )
      }
    })
  })
}
