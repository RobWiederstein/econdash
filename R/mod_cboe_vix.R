#' cboe_vix UI Function
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
mod_cboe_vix_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      highchartOutput(ns("chart1"))
    )
  )
}

#' cboe_vix Server Functions
#'
#' @noRd
mod_cboe_vix_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      hc <- vix |>
        hchart("line", hcaes(x = .data$date,
                             y = .data$close,
                             group = .data$symbol
        )) |>
        hc_xAxis(title = list(text = ''),
                 plotBands = us_recessions) |>
        hc_title(
          text = "CBOE Volatility Index (^VIX)"
        ) |>
        hc_subtitle(
          text = "2007 - current"
        ) |>
        hc_caption(text = "<b>Source:</b> Yahoo Finance."
        )
      hc
    })
  })
}

## To be copied in the UI
# mod_cboe_vix_ui("cboe_vix_ui_1")

## To be copied in the server
# mod_cboe_vix_server("cboe_vix_ui_1")
