#' fred_piger_rec_prob UI Function
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
mod_fred_piger_rec_prob_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      highchartOutput(ns("chart1"))
    )
  )
}

#' fred_piger_rec_prob Server Functions
#'
#' @noRd
mod_fred_piger_rec_prob_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      hc <- piger_rec_prob |>
        hchart("line",
               hcaes(x = .data$date, y = .data$value),
               name = "Probability",
               tooltip = list(pointFormat = "{point.x:%m-%Y}: {point.y}%")) |>
        hc_title(
          text = "U.S. Recession Probability"
        ) |>
        hc_subtitle(
          text = ""
        ) |>
        hc_caption(text = "FRED Database"
        ) |>
        hc_xAxis(title = list(text = ''),
                 plotBands = us_recessions) |>
        hc_yAxis(title = list(text = ''),
                 labels = list(format = "{value}%"),
                 max = 100)
      hc
    })
  })
}

## To be copied in the UI
# mod_fred_piger_rec_prob_ui("fred_piger_rec_prob_ui_1")

## To be copied in the server
# mod_fred_piger_rec_prob_server("fred_piger_rec_prob_ui_1")
