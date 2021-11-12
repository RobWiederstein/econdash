#' csushpinsa UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_csushpinsa_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      fluidRow(
        highcharter::highchartOutput(ns("csushpinsa_plot"))
      )
    )
  )
}

#' csushpinsa Server Functions
#'
#' @noRd
mod_csushpinsa_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$csushpinsa_plot <- highcharter::renderHighchart({
      x <- xts::xts(econDash::csushpinsa$value, econDash::csushpinsa$date)
      highcharter::hchart(x)
    })
  })
}

## To be copied in the UI
# mod_csushpinsa_ui("csushpinsa_ui_1")

## To be copied in the server
# mod_csushpinsa_server("csushpinsa_ui_1")
