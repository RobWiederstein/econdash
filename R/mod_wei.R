#' wei UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_wei_ui <- function(id) {
    ns <- NS(id)
    tagList(
        fluidPage(
            fluidRow(
                highcharter::highchartOutput(ns("wei_plot"))
            )
        )
    )
}

#' wei Server Functions
#'
# importFrom econDash wei
#' @noRd
mod_wei_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        output$wei_plot <- highcharter::renderHighchart({
            x <- xts::xts(econDash::wei$value, econDash::wei$date)
            highcharter::hchart(x)
        })
    })
}

## To be copied in the UI
# mod_wei_ui("wei_ui_1")

## To be copied in the server
# mod_wei_server("wei_ui_1")
