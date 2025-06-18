box::use(
  shiny[bootstrapPage, moduleServer, NS, renderText, tags, textOutput],
  dplyr[select, mutate, group_by, filter, arrange, pull],
  qs[qread],
  here[here],
)

box::use(
  app/logic/read_data[complete_data, map_indicator],
)

box::use(
  app/view/navbar_section,
  app/view/map,
  app/view/line_chart,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    tags$div(
      class = "content-container",
      style = "max-width: 90% ; margin-inline: auto;",
      # Top Navbar ----
      navbar_section$ui(ns("navbar")),
      # Dashboard Main Page ----
      map$ui(ns("map")),
      line_chart$ui(ns("line"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    navbar_section$server("navbar")
    filtered_map_df <- qread("app/data/data_map.qs") |>
      filter(Year == 2020)

    map$server("map", filtered_map_df)
    line_chart$server("line")
  })
}
