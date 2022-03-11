#' umcsent UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_umcsent_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      fluidRow(
        highcharter::highchartOutput(ns("umcsent_plot"))
      )
    )

  )
}

#' umcsent Server Functions
#'
#' @noRd
mod_umcsent_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$umcsent_plot <- highcharter::renderHighchart({
      x <- xts::xts(umcsent$value, umcsent$date)
      highcharter::hchart(x) |>
        hc_xAxis(plotBands = us_recessions)
    })
  })
}

## To be copied in the UI
# mod_umcsent_ui("umcsent_ui_1")

## To be copied in the server
# mod_umcsent_server("umcsent_ui_1")
