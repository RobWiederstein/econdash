#' gdp_per_capita UI Function
#'
#' @description gdp per capita
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import highcharter
#' @import shinyWidgets
#' @importFrom rlang .data
mod_gdp_per_capita_ui <- function(id) {
  ns <- NS(id)
  tagList(
    highchartOutput(ns("chart1")),
    hr(),
    fluidRow(
      column(
        6,
        tags$h3("Country:"),
        pickerInput(
          inputId = ns("location"),
          choices = sort(unique(oecd_gdp_per_capita$location)),
          selected = "USA",
          multiple = T,
          options = list(
            `actions-box` = TRUE,
            `deselect-all-text` = "None",
            `select-all-text` = "All",
            `none-selected-text` = "zero"
          )
        )
      ),
      column(
        6,
        tags$h3("Indicator:"),
        pickerInput(
          inputId = ns("measure"),
          choices = sort(unique(oecd_gdp_per_capita$measure)),
          selected = sort(unique(oecd_gdp_per_capita$measure))[1],
          multiple = F
        )
      )
    )
  )
}

#' gdp_per_capita Server Functions
#'
#' @noRd
mod_gdp_per_capita_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    df_filtered <- reactive({
      oecd_gdp_per_capita |>
        dplyr::filter(.data$location %in% input$location) |>
        dplyr::filter(.data$measure %in% input$measure)
    })
    output$chart1 <- renderHighchart({
      data <- df_filtered()
      hc <- data |>
        hchart("line", hcaes(
          x = .data$obs_time,
          y = .data$obs_value,
          group = .data$location
        )) |>
        hc_xAxis(
          title = list(text = ""),
          type = "datetime",
          plotBands = us_recessions
        ) |>
        hc_yAxis(title = list(text = input$measure))
      hc
    })
  })
}

## To be copied in the UI
# mod_gdp_per_capita_ui("gdp_per_capita_ui_1")

## To be copied in the server
# mod_gdp_per_capita_server("gdp_per_capita_ui_1")
