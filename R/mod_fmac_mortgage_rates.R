#' fmac_mortgage_rates UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom rlang .data
mod_fmac_mortgage_rates_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      highchartOutput(ns("chart1"))
    )
  )
}

#' fmac_mortgage_rates Server Functions
#'
#' @noRd
mod_fmac_mortgage_rates_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      data = fmac
      hc <- data |>
        hchart("line", hcaes(x = .data$date,
                             y = .data$value,
                             group = .data$mortgage,
        )) |>
        hc_title(
          text = "U.S. Mortgage Rates"
        ) |>
        hc_subtitle(
          text = "1971 - Current"
        ) |>
        hc_caption(text = "<b>Source:</b> Freddie Mac"
        ) |>
        hc_xAxis(title = list(text = ''),
                 plotBands = us_recessions) |>
        hc_yAxis(title = list(text = ''),
                 labels = list(format = "{value}%"))
      hc
    })
  })
}

## To be copied in the UI
# mod_fmac_mortgage_rates_ui("fmac_mortgage_rates_ui_1")

## To be copied in the server
# mod_fmac_mortgage_rates_server("fmac_mortgage_rates_ui_1")
