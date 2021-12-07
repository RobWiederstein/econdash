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
mod_gdp_total_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
    # App title ----
    highchartOutput(ns("chart1")),
    hr(),
    fluidRow(
      column(
        6,
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
      ),
      column(
        6,
        tags$h3("Indicator:"),
        pickerInput(
          inputId = ns("measure"),
          choices = sort(unique(oecd_gdp_total$measure)),
          selected = sort(unique(oecd_gdp_total$measure))[1],
          multiple = F
        ),
      )
    )
  )
  )
}

#' gdp_total Server Functions
#'
#' @noRd
mod_gdp_total_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    df_filtered <- reactive({
      oecd_gdp_total |>
        dplyr::filter(.data$location %in% input$location) |>
        dplyr::filter(.data$measure %in% input$measure)
    })
    output$chart1 <- renderHighchart({
      data <- df_filtered()
      hc <- data |>
        hchart("line", hcaes(x = .data$obs_time,
                             y = .data$obs_value,
                             group = .data$location)) |>
        hc_xAxis(
          title = list(text = ""),
          type = "datetime",
          plotBands = us_recessions
        ) |>
        hc_yAxis(
          title = list(text = "U.S. dollars"),
          labels = list(format = "${value}T")
        ) |>
        hc_subtitle(
          text = "US $, constant prices & PPP, ref. year 2015",
          align = "right",
          x = -40
        )
      hc
    })
  })
}

## To be copied in the UI
# mod_gdp_total_ui("gdp_total_ui_1")

## To be copied in the server
# mod_gdp_total_server("gdp_total_ui_1")
