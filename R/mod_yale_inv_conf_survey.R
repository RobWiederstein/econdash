#' yale_inv_conf_survey UI Function
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
mod_yale_inv_conf_survey_ui <- function(id){
  ns <- NS(id)
  tagList(
    highchartOutput(ns("chart1")),
    h2("About"),
    hr(),
    p('Yale Management School publishes several investor confidence surveys, originally conceived and designed by Robert J Shiller, the famed Yale economist.  Fumiko Kon-Ya and Yoshiro Tsutsui of Japan also assisted in the collection of the data. Two groups are surveyed: wealthy individual investors and institutional investors. The surveys are conducted monthly and the results are reported as an average of the six previous months surveys. Each group typically returns one hundred surveys resulting in a standard error of plus or minus five percent.'),
    br(),
    p('The question verbatim is as follows: "How much of a change in percentage terms do you expect in the following (use a plus sign before your number to indicate an expected increase, or minus sign to indicate an expected decrease, leave blanks where you do not know):"'),
    tags$ul(tags$li('1 month'),
            tags$li('in 3 months'),
            tags$li('in 6 months'),
            tags$li('in 1 year'),
            tags$li('in 10 years')),
    p('The plot above reports the six month average of individual and institutional investors\' percentage estimate of the gain or loss in the Dow Jones Index in one year.'),
    h2("Research"),
    hr(),
    HTML('<a href=\'https://www.tandfonline.com/doi/abs/10.1207/S15327760JPFM0101_05\'>Shiller, Robert J. "Measuring Bubble Expectations and Investor Confidence." Journal of Psychology and Financial Markets 1, 1 (2000): 49-60.</a>'),
    br(),
    br(),
    HTML('<a href=\'https://bit.ly/34DkHwx\'>Shiller, Robert, J. 2003. "From Efficient Markets Theory to Behavioral Finance ." Journal of Economic Perspectives, 17 (1): 83-104.</a>')
  )
}

#' yale_inv_conf_survey Server Functions
#'
#' @noRd
mod_yale_inv_conf_survey_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      hc <-
        yale_inv_conf_survey |>
        hchart("line", hcaes(x = .data$date, y = .data$value, group = .data$variable)) |>
        hc_title(
          text = "U.S. Confidence in Dow Increase"
        ) |>
        hc_subtitle(
          text = "Within one year"
        ) |>
        hc_caption(text = "<b>Source:</b><a href='https://bit.ly/3upSODj'> Yale School of Management</a>") |>
        hc_xAxis(
          title = list(text = ""),
          plotBands = us_recessions
        ) |>
        hc_yAxis(
          title = list(text = ""),
          labels = list(format = "{value}%"),
          min = 0,
          max = 100
        )
      hc
    })
  })
}

## To be copied in the UI
# mod_yale_inv_conf_survey_ui("yale_inv_conf_survey_ui_1")

## To be copied in the server
# mod_yale_inv_conf_survey_server("yale_inv_conf_survey_ui_1")
