box::use(
  shiny[...],
)

create_image_path <- function(path) {
  base_path <- "static/img"

  if (nchar(base_path) < 1) {
    file_path <- sprintf(
      fmt = "../%s",
      path
    )
  } else {
    file_path <- sprintf(
      fmt = "../%s/%s",
      base_path,
      path
    )
  }

  return(file_path)
}

topic_section <- function(header,
                          description) {
  div(
    h4(class = "about-header", header),
    div(
      class = "about-descr",
      description
    )
  )
}

tag <- function(tag_string, hyperlink) {
  a(
    class = "tag-item",
    href = hyperlink,
    target = "_blank",
    rel = "noopener noreferrer",
    icon("link"),
    tag_string
  )
}

card <- function(href_link,
                 img_link,
                 card_header,
                 card_text) {
  div(
    class = "card-package",
    a(
      class = "card-img",
      href = href_link,
      target = "_blank",
      rel = "noopener noreferrer",
      img(
        src = img_link,
        alt = card_header
      )
    ),
    div(
      class = "card-heading",
      card_header
    ),
    div(
      class = "card-content",
      card_text
    ),
    a(
      class = "card-footer",
      href = href_link,
      target = "_blank",
      rel = "noopener noreferrer",
      "Learn more"
    )
  )
}

empty_card <- function() {
  div(
    class = "card-empty",
    a(
      href = "https://shiny.tools/#rhino",
      target = "_blank",
      rel = "noopener noreferrer",
      shiny::icon("arrow-circle-right"),
      div(
        class = "card-empty-caption",
        "More Appsilon Technologies"
      )
    )
  )
}

appsilon <- function() {
  div(
    class = "appsilon-card",
    div(
      class = "appsilon-pic",
      a(
        href = "https://appsilon.com/",
        target = "_blank",
        rel = "noopener noreferrer",
        img(
          src = create_image_path("appsilon-logo.png"),
          alt = "Appsilon"
        )
      )
    ),
    div(
      class = "appsilon-summary",
      "We create, maintain, and develop Shiny applications
      for enterprise customers all over the world. Appsilon
      provides scalability, security, and modern UI/UX with
      custom R packages that native Shiny apps do not provide.
      Our team is among the world's foremost experts in R Shiny
      and has made a variety of Shiny innovations over the
      years. Appsilon is a proud Posit Full Service
      Certified Partner."
    )
  )
}

about_section <- div(
  div(
    class = "about-section",
    topic_section(
      header = "About the project",
      description = div(
        "The Global Freshwater Resources Dashboard
        presents a comprehensive visualization of
        the available freshwater resources per
        country and per capita, utilizing data from
        AQUASTAT Statistics. This dynamic dashboard
        combines a geographic map and trendline
        charts to offer valuable insights into water
        resource distribution and changes over time."
      )
    ),
    topic_section(
      header = "Dataset Info",
      description = "Data for this dashboard is sourced
      from the reliable AQUASTAT Statistics database ,
      managed by the Food and Agriculture Organization
      (FAO) of the United Nations. AQUASTAT collects,
      analyzes, and disseminates information on water
      resources, water uses, and agricultural water
      management for over 180 countries."
    ),
    div(
      class = "about-tag",
      tag(
        tag_string = "AQUASTAT Statistics database",
        hyperlink = paste0(
          "https://tableau.apps.fao.org/views/AQUASTATDashboard/country_dashboard",
          "?%3Aembed=y&%3AisGuestRedirectFromVizportal=y"
        )
      )
    ),
    hr(),
    div(
      h4(
        class = "about-header",
        "Powered by"
      ),
      div(
        class = "card-section",
        card(
          href_link = "https://appsilon.github.io/rhino/",
          img_link = create_image_path("rhino.png"),
          card_header = "Rhino",
          card_text = "Rhino is an Open-Source Package developed by Appsilon to
              help the R community make more professional Shiny Apps. Rhino allows you to
              create Shiny apps The Appsilon Way - like a fullstack software engineer.
              Apply best software engineering practices, modularize your code,
              test it well, make UI beautiful, and think about user adoption
              from the very beginning."
        ),
        empty_card()
      )
    ),
    appsilon()
  )
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      id = "info_btn",
      shiny::icon("info-circle")
    ),
    tags$script(
      HTML(
        sprintf(
          fmt = "$('#%s').parent().click(() => {
            Shiny.setInputValue('%s', 'event', { priority: 'event'})
          })",
          "info_btn",
          ns("open_modal")
        )
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(
      input$open_modal,
      ignoreNULL = TRUE,
      {
        showModal(
          modalDialog(
            easyClose = TRUE,
            title = "Fresh Water Resources",
            about_section
          )
        )
      }
    )
  })
}
