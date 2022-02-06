#' nyfed_yield_spread UI Function
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
mod_nyfed_yield_spread_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      uiOutput(ns("chart1"))
    )
  )
}

#' nyfed_yield_spread Server Functions
#'
#' @noRd
mod_nyfed_yield_spread_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderUI({
      hw_grid(list(
        yield_spread |>
          dplyr::filter(.data$variable == "rec_prob") |>
          hchart("line",
                 hcaes(x = .data$date, y = .data$value),
                 name = "Probability",
                 tooltip = list(headerFormat = "<b>Recession w/i 12 mon</b><br/>",
                                pointFormat = "Date: {point.x:%m-%Y}<br/>
			       	       Chance: {point.y}%"
                 )
          ) |>
          hc_title(
            text = "U.S. Recession Probability within 12 Months,
				as Forecast by Treasury Spread"
          ) |>
          hc_subtitle(
            text = "Monthly Average"
          ) |>
          hc_caption(text = ""
          ) |>
          hc_xAxis(title = list(text = ''),
                   plotBands = us_recessions) |>
          hc_yAxis(title = list(text = ''),
                   labels = list(format = "{value}%"),
                   max = 100),
        yield_spread |>
          dplyr::filter(.data$variable == "spread") |>
          hchart("line",
                 hcaes(x = date, y = .data$value),
                 name = "Spread",
                 tooltip = list(headerFormat = "<b>10 yr % - 3 mo %</b><br/>",
                                pointFormat = "Date: {point.x:%m-%Y}<br/>
			       	       Spread: {point.y:.2f}%"
                 )
          ) |>
          hc_title(
            text = "U.S. Treasury Spread: 10 Year Bond - 3 Mon Bill"
          ) |>
          hc_subtitle(
            text = "Monthly Average"
          ) |>
          hc_caption(text = "<b>Source:</b> New York Federal Reserve"
          ) |>
          hc_xAxis(title = list(text = ''),
                   plotBands = us_recessions) |>
          hc_yAxis(title = list(text = ''),
                   labels = list(format = "{value}%"))
      ), ncol = 1, rowheight = 300
      )
    })
  })
}

## To be copied in the UI
# mod_nyfed_yield_spread_ui("nyfed_yield_spread_ui_1")

## To be copied in the server
# mod_nyfed_yield_spread_server("nyfed_yield_spread_ui_1")
