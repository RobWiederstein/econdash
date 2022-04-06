#' nyfed_qhdc_mo_cs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import highcharter
mod_nyfed_qhdc_mo_cs_ui <- function(id){
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
      p('-')
  )
}

#' nyfed_qhdc_mo_cs Server Functions
#'
#' @noRd
mod_nyfed_qhdc_mo_cs_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$chart1 <- renderHighchart({
    highchart() |>
      hc_chart(type = "column") |>
      hc_plotOptions(column = list(stacking = "normal")) |>
      # y axis
      hc_yAxis(title = "",
               labels = list(format = '${value}B')) |>
      hc_xAxis(
        categories = nyfed_qhdc_mo_cs$quarter
      ) |>
      hc_add_series(
        name="760+",
        data = nyfed_qhdc_mo_cs$`760+`
      ) |>
      hc_add_series(
        name="720-759",
        data = nyfed_qhdc_mo_cs$`720-759`
      ) |>
      hc_add_series(
        name="660-719",
        data = nyfed_qhdc_mo_cs$`660-719`
      ) |>
      hc_add_series(
        name="620-659",
        data = nyfed_qhdc_mo_cs$`620-659`
      ) |>
      hc_add_series(
        name="<620",
        data = nyfed_qhdc_mo_cs$`<620`
      ) |>
      #labels
      hc_title(text = "Mortgage Origination Volume by Credit Score"
      ) |>
      hc_subtitle(text = ""
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
        borderWidth = 3,
        table = T,
        decimal = 2,
        valueSuffix = "B",
        valuePrefix = "$"
      )
    })
  })
}

## To be copied in the UI
# mod_nyfed_qhdc_mo_cs_ui("nyfed_qhdc_mo_cs_ui_1")

## To be copied in the server
# mod_nyfed_qhdc_mo_cs_server("nyfed_qhdc_mo_cs_ui_1")
