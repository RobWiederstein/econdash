#' gdp_per_capita UI Function
#'
#' @description gdp per capita
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import highcharter
#' @import shinyWidgets
#' @importFrom rlang .data
mod_oecd_per_capita_ui <- function(id) {
  ns <- NS(id)
  tagList(
    highchartOutput(ns("chart1")),
    hr(),
    fluidRow(
      column(
        12,
        tags$h3("Country:"),
        pickerInput(
          inputId = ns("location"),
          choices = sort(unique(oecd_gdp_per_capita$location)),
          selected = "USA",
          multiple = T,
          options = list(
            `actions-box` = TRUE,
            `deselect-all-text` = "None",
            `select-all-text` = "All",
            `none-selected-text` = "zero"
          )
        )
      )
    ),
    h2("About"),
    hr(),
    HTML("Per capita GDP is a global measure for gauging the prosperity of nations and is used by
         economists, along with GDP, to analyze the prosperity of a country based on its
         economic growth. The data above are reported with Purchasing Power Parity in U.S. dollars
         to account for the costs of living among the different countries. For additional
         information, see the Wikipedia <a href='https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)_per_capita'>
         article</a> on nominal GDP."),
    h2("Research"),
    hr(),
    HTML("-"),
    h2("Frequency"),
    hr(),
    HTML("Published monthly."),
    h2("Citation"),
    hr(),
    p('OECD (2022), "GDP per capita and productivity levels", OECD Productivity Statistics (database), https://doi.org/10.1787/data-00686-en (accessed on 12 February 2022).')
  )
}

#' gdp_per_capita Server Functions
#'
#' @noRd
mod_oecd_per_capita_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    df_filtered <- reactive({
      oecd_gdp_per_capita |>
        dplyr::filter(.data$location %in% input$location)
    })
    output$chart1 <- renderHighchart({
      data <- df_filtered()
      hc <- data |>
        hchart("line", hcaes(
          x = .data$obs_time,
          y = .data$obs_value,
          group = .data$location
        )) |>
        hc_title(text = "OECD GDP Per Capita") |>
        hc_subtitle(
          text = "US $, constant prices & PPP, ref. year 2015",
          align = "right",
          x = -40
        ) |>
        hc_tooltip(valuePrefix = ' $',
                   valueSuffix = 'USD',
                   table = TRUE,
                   sort = TRUE,
                   shared = TRUE) |>
        hc_credits(
          enabled = TRUE,
          text = "<b>Cite:</b> OECD.",
          href = "https://data.oecd.org/gdp/gross-domestic-product-gdp.htm"
        ) |>
        hc_xAxis(
          title = list(text = ""),
          type = "datetime",
          plotBands = us_recessions
        ) |>
        hc_yAxis(title = list(text = input$measure))
      hc
    })
  })
}

## To be copied in the UI
# mod_oecd_per_capita_ui("gdp_per_capita_ui_1")

## To be copied in the server
# mod_oecd_per_capita_server("gdp_per_capita_ui_1")
