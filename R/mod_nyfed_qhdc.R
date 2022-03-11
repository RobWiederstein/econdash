#' nyfed_qhdc UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import highcharter
mod_nyfed_qhdc_ui <- function(id){
  ns <- NS(id)
  tagList(
    highchartOutput(ns("chart1")),
    hr(),
    h2("About"),
    hr(),
    p("This data is published by the New York Federal Reserve and is maintained by the Center for Microeconomic Data. The effort is one of two main data collection efforts:  the New York Fed Consumer Credit Panel (CCP) and the Survey of Consumer Expectations (SCE). The quarterly report contains 20+ charts on the state of household debt and credit.  The above chart is only one of many."),
    HTML(""),
    h2("Research"),
    hr(),
    HTML("<a href='https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1719116'>Lee, Donghoon and van der Klaauw, H. Wilbert, An Introduction to the FRBNY Consumer Credit Panel (November 1, 2010). FRB of New York Staff Report No. 479, Available at SSRN: https://ssrn.com/abstract=1719116 or http://dx.doi.org/10.2139/ssrn.1719116</a>"),
    h2("Frequency"),
    hr(),
    HTML("Published quarterly."),
    h2("Citation"),
    hr(),
    p('OECD (2022), "GDP per capita and productivity levels", OECD Productivity Statistics (database), https://doi.org/10.1787/data-00686-en (accessed on 12 February 2022).')
  )
}

#' nyfed_qhdc Server Functions
#'
#' @noRd
mod_nyfed_qhdc_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
      highchart() |>
        hc_chart(type = "column") |>
        hc_plotOptions(column = list(stacking = "normal")) |>
        # y axis
        hc_yAxis(title = "",
                 labels = list(format = '${value}T')) |>
        hc_xAxis(
          categories = nyfed_qhdc$quarter
        ) |>
        hc_add_series(
          name="Other",
          data = nyfed_qhdc$other
        ) |>
        hc_add_series(
          name="Student Loan",
          data = nyfed_qhdc$student_loan
        ) |>
        hc_add_series(
          name="Auto Loan",
          data = nyfed_qhdc$auto_loan
        ) |>
        hc_add_series(
          name="Credit Card",
          data = nyfed_qhdc$credit_card
        ) |>
        hc_add_series(name="Auto Loan",
                      data = nyfed_qhdc$auto_loan
        ) |>
        hc_add_series(name="HELOC",
                      data = nyfed_qhdc$heloc) |>
        hc_add_series(name="Mortgage",
                      data = nyfed_qhdc$mortgage
        ) |>
        #labels
        hc_title(text = "Consumer Debt Total by Loan Type"
        ) |>
        hc_subtitle(text = "Infl. Adj 2020 Base Year"
        ) |>
        hc_caption(
          text = "",
          useHTML = TRUE
        ) |>
        hc_credits(
          text = "New York Fed -- Center for Microeconomic Data",
          href = "https://www.newyorkfed.org/microeconomics",
          enabled = TRUE
        ) |>
        # legend
        hc_legend(
          align = "right",
          verticalAlign = "top",
          layout = "vertical",
          x = 0, y = 100
        ) |>
        # tooltip
        hc_tooltip(
          crosshairs = TRUE,
          backgroundColor = "#F0F0F0",
          shared = TRUE,
          borderWidth = 5
        )
    })


  })
}

## To be copied in the UI
# mod_nyfed_qhdc_ui("nyfed_qhdc_ui_1")

## To be copied in the server
# mod_nyfed_qhdc_server("nyfed_qhdc_ui_1")
