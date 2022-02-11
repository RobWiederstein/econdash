#' finra_margin_debt UI Function
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
mod_finra_margin_debt_ui <- function(id){
  ns <- NS(id)
  tagList(
    highchartOutput(ns("chart1")),
    h2("About"),
    hr(),
    p('According'),
    br(),
    br(),
    p('The chart '),
    h2("Research"),
    hr(),
    HTML('<a href=\'https://www.tandfonline.com/doi/abs/10.2469/faj.v56.n2.2340\'>Fisher, Kenneth L., and Meir Statman. "Investor sentiment and stock returns." Financial Analysts Journal 56.2 (2000): 16-23.</a>'),
    br(),
    br(),
    HTML('<a href=\'https://www.sciencedirect.com/science/article/abs/pii/S0927539803000422\'>Brown, Gregory W., and Michael T. Cliff. "Investor sentiment and the near-term stock market." Journal of empirical finance 11.1 (2004): 1-27.</a>')
  )
}

#' finra_margin_debt Server Functions
#'
#' @noRd
mod_finra_margin_debt_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      hchart(finra_margin_debt, 'line',
             hcaes(.data$date,
                   .data$net_margin)) |>
        hc_title(
          text = "U.S. Investor Net Margin Balances"
        ) |>
        hc_subtitle(
          text = "Within one year"
        ) |>
        hc_caption(text = "<b>Source:</b> FINRA") |>
        hc_xAxis(
          title = list(text = ""),
          plotBands = us_recessions
        ) |>
        hc_yAxis(
          title = list(text = ""),
          labels = list(format = "{value}B")
        )
    })
  })
}

## To be copied in the UI
# mod_finra_margin_debt_ui("finra_margin_debt_ui_1")

## To be copied in the server
# mod_finra_margin_debt_server("finra_margin_debt_ui_1")
