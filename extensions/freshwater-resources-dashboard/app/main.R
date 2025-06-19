box::use(
  dplyr[arrange, filter, group_by, mutate, pull, select],
  here[here],
  qs[qread],
  shiny[bootstrapPage, moduleServer, NS, renderText, tags, textOutput],
)

box::use(
  app/logic/read_data[complete_data, map_indicator],
  app/view/line_chart,
  app/view/map,
  app/view/navbar_section,
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
