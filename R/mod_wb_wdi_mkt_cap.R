#' wb_wdi_mkt_cap UI Function
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
mod_wb_wdi_mkt_cap_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      highcharter::highchartOutput(ns("chart1")),
      hr(),
      fluidRow(
        column(
          6,
          tags$h3("Country:"),
          pickerInput(
            inputId = ns("country"),
            label = "",
            choices = sort(unique(wb_wdi_mkt_cap$country)),
            selected = "US",
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
          tags$h3("Indicator: "),
          pickerInput(
            inputId = ns("indicator"),
            label = "",
            choices = sort(unique(wb_wdi_mkt_cap$indicator)),
            selected = sort(unique(wb_wdi_mkt_cap$indicator)),
            multiple = T,
            options = list(
              `actions-box` = TRUE,
              `deselect-all-text` = "None",
              `select-all-text` = "All",
              `none-selected-text` = "zero"
            )
          )
        )
      )
    )
  )
}

#' wb_wdi_mkt_cap Server Functions
#'
#' @noRd
mod_wb_wdi_mkt_cap_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    df_filtered <- reactive({
      wb_wdi_mkt_cap |>
        dplyr::filter(.data$country %in% input$country) |>
        dplyr::filter(.data$indicator %in% input$indicator)
    })
    output$chart1 <- renderHighchart({
      data <- df_filtered()
      hc <-
        df_filtered() |>
        hchart("line",
               hcaes(
                 x = .data$period,
                 y = .data$value,
                 group = .data$country)) |>
        hc_xAxis(title = list(text = ""),
                 type = 'datetime',
                 plotBands = us_recessions) |>
        hc_yAxis(title = list(text = ""),
                 labels = list(format = '{value}%')) |>
        hc_title(text = "Market Cap as % of Country GDP")
      hc
    })
  })
}

## To be copied in the UI
# mod_wb_wdi_mkt_cap_ui("wb_wdi_mkt_cap_ui_1")

## To be copied in the server
# mod_wb_wdi_mkt_cap_server("wb_wdi_mkt_cap_ui_1")
