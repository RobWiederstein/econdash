#' fred_housing_starts UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom rlang .data
#' @import highcharter
mod_fred_housing_starts_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      highchartOutput(ns("chart1"))
      )
    )
}

#' fred_housing_starts Server Functions
#'
#' @noRd
mod_fred_housing_starts_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      hc <- houst |>
        hchart("line", hcaes(x = .data$date,
                             y = .data$value,
                             group = .data$series_id
        )) |>
        hc_title(
          text = "U.S. Housing Starts All Units"
        ) |>
        hc_subtitle(
          text = "2000 - current"
        ) |>
        hc_caption(text = "<b>Source:</b> U.S. Census Bureau"
        ) |>
        hc_xAxis(title = list(text = ''),
                 plotBands = us_recessions) |>
        hc_yAxis(title = list(text = ''),
                 labels = list(format = "{value}m"))
      hc
    })
  })
}

## To be copied in the UI
# mod_fred_housing_starts_ui("fred_housing_starts_ui_1")

## To be copied in the server
# mod_fred_housing_starts_server("fred_housing_starts_ui_1")
