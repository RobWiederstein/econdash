#' pfed_ads_bus_conditions UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom rlang .data
mod_pfed_ads_bus_conditions_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      highchartOutput(ns("chart1"))
    )
  )
}

#' pfed_ads_bus_conditions Server Functions
#'
#' @noRd
mod_pfed_ads_bus_conditions_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      data <- xts::xts(adsidx$ads_idx, adsidx$date)
      hc <- highcharter::hchart(data) |>
        hc_xAxis(title = list(text = ''),
                 plotBands = us_recessions) |>
        hc_title(
          text = "Aruoba-Diebold-Scotti Business Conditions Index"
        ) |>
        hc_subtitle(
          text = "2000 - current"
        ) |>
        hc_caption(text = "<b>Source:</b> Federal Reserve Bank of Philadelphia."
        )
      hc
    })
  })
}

## To be copied in the UI
# mod_pfed_ads_bus_conditions_ui("pfed_ads_bus_conditions_ui_1")

## To be copied in the server
# mod_pfed_ads_bus_conditions_server("pfed_ads_bus_conditions_ui_1")
