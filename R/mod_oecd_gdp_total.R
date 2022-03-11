#' gdp_total UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import highcharter
#' @import shinyWidgets
#' @importFrom rlang .data
mod_oecd_gdp_total_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidPage(
      # App title ----
      highchartOutput(ns("chart1")),
      hr(),
      fluidRow(
        column(
          12,
          tags$h3("Country:"),
          pickerInput(
            inputId = ns("location"),
            choices = sort(unique(oecd_gdp_total$location)),
            selected = c("USA"),
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
      HTML("According to the OECD, Gross domestic product (GDP) is the standard measure of the value added created through the production of goods and services in a country during a certain period. GDP as a measure of overall economic success is frequently criticized.  The OECD noted, \"it falls short of providing a suitable measure of people's material well-being for which alternative indicators may be more appropriate.\" More information can be found on the OECD  <a href='https://data.oecd.org/gdp/gross-domestic-product-gdp.htm'>webpage</a>."),
      h2("Research"),
      hr(),
      HTML("<a href='https://www.degruyter.com/document/doi/10.1515/9781400873630/html'>Coyle, Diane. GDP: A Brief but Affectionate History, Princeton: Princeton University Press, 2015. https://doi.org/10.1515/9781400873630</a>"),
      h2("Frequency"),
      hr(),
      HTML("Published monthly."),
      h2("Citation"),
      hr(),
      p('OECD (2022), Gross domestic product (GDP) (indicator). doi: 10.1787/dc2f7aec-en (Accessed on 11 February 2022)')
    )
  )
}

#' gdp_total Server Functions
#'
#' @noRd
mod_oecd_gdp_total_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    df_filtered <- reactive({
      oecd_gdp_total |>
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
        hc_title(text = "OECD Total GDP by Country") |>
        hc_subtitle(
          text = "US $, constant prices & PPP, ref. year 2015",
          align = "right",
          x = -40
        ) |>
        hc_tooltip(valuePrefix = ' $',
                   valueSuffix = 'T',
                   table = TRUE,
                   sort = TRUE,
                   shared = TRUE,
                   crosshairs = TRUE) |>
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
        hc_yAxis(
          title = list(text = "U.S. dollars"),
          labels = list(format = "${value}T")
        )
      hc
    })
  })
}

## To be copied in the UI
# mod_oecd_gdp_total_ui("gdp_total_ui_1")

## To be copied in the server
# mod_oecd_gdp_total_server("gdp_total_ui_1")
