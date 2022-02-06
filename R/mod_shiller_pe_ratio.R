#' shiller_pe_ratio UI Function
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
mod_shiller_pe_ratio_ui <- function(id){
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

#' shiller_pe_ratio Server Functions
#'
#' @noRd
mod_shiller_pe_ratio_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      shiller |>
        highcharter::hchart(tooltip = list(valueDecimals = 1,
                                           pointFormat = "Shiller PE Ratio: <b>{point.y}</b>"
        )) |>
        hc_title(
          text = "Shiller PE Ratio for the S & P 500"
        ) |>
        hc_subtitle(
          text = "1875 - current"
        ) |>
        hc_caption(text = "<b>Source:</b><a href='https://bit.ly/3J7Bd7f'> Quandl</a>")|>
        hc_yAxis(title = list(text = ''),
                 labels = list(format = "{value}"),
                 plotLines = list(list(value = 20.37,
                                       color = "black",
                                       width = 1,
                                       dashStyle = "shortdash",
                                       label = list(text = "mean = 20.37",
                                                    align = 'right',
                                                    x = -20)))) |>
        hc_xAxis(title = list(text = ''),
                 plotBands = us_recessions)
    })
  })
}

## To be copied in the UI
# mod_shiller_pe_ratio_ui("shiller_pe_ratio_ui_1")

## To be copied in the server
# mod_shiller_pe_ratio_server("shiller_pe_ratio_ui_1")
