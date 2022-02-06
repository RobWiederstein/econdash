#' aaii_inv_sentiment UI Function
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
mod_aaii_inv_sentiment_ui <- function(id){
  ns <- NS(id)
  tagList(
      highchartOutput(ns("chart1")),
      h2("About"),
      hr(),
      p('According to the American Association of Individual Investors (AAII), its members answer the same simple question each week and have done so since 1987. (Only results from 2000 are published here.) The results are referred to as the AAII Investor Sentiment Survey and give insight as to individual investors\' perception of the market. The weekly survey is widely followed with financial publications like  Barron\'s and Bloomberg publishing the results. The question reads, \'Do they feel the direction of the stock market over the next six months will be up (bullish), no change (neutral) or down (bearish)?\''),
      br(),
      br(),
      p('The chart above takes the percentage of respondents responding that they are bullish over the next six months and subtracts the percentage of those responding that they are bearish.  Where bulls exceed bears, then the number is positive and, where bears exceed bulls, the number is negative.'),
      h2("Research"),
      hr(),
      HTML('<a href=\'https://www.tandfonline.com/doi/abs/10.2469/faj.v56.n2.2340\'>Fisher, Kenneth L., and Meir Statman. "Investor sentiment and stock returns." Financial Analysts Journal 56.2 (2000): 16-23.</a>'),
      br(),
      br(),
      HTML('<a href=\'https://www.sciencedirect.com/science/article/abs/pii/S0927539803000422\'>Brown, Gregory W., and Michael T. Cliff. "Investor sentiment and the near-term stock market." Journal of empirical finance 11.1 (2004): 1-27.</a>')
  )
}

#' aaii_inv_sentiment Server Functions
#'
#' @noRd
mod_aaii_inv_sentiment_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      aaii_inv_sent |>
        hchart("line", hcaes(.data$month,
                             .data$percent,
                             group = .data$variable),
               tooltip = list(valueDecimals = 1,
                              pointFormat = "{point.y} %")) |>
        hc_title(
          text = "AAII Investor Bull-Bear Spread"
        ) |>
        hc_subtitle(
          text = "Monthly Average"
        ) |>
        hc_caption(text = "<b>Source:</b><a href='https://www.aaii.com/sentimentsurvey/sent_results'> American Assoc. of Individual Investors</a>")|>
        hc_yAxis(title = list(text = ''),
                 labels = list(format = "{value}%"),
                 plotLines = list(list(value = 0, color = "black", width = 2,
                                       dashStyle = "shortdash"))) |>
        hc_xAxis(title = list(text = ''),
                 plotBands = us_recessions)
    })
  })
}

## To be copied in the UI
# mod_aaii_inv_sentiment_ui("aaii_inv_sentiment_ui_1")

## To be copied in the server
# mod_aaii_inv_sentiment_server("aaii_inv_sentiment_ui_1")
