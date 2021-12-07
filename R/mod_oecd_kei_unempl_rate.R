#' oecd_kei_unempl_rate UI Function
#'
#' @description OECD unemployment rate
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import highcharter
#' @import shinyWidgets
#' @importFrom rlang .data
mod_oecd_kei_unempl_rate_ui <- function(id){
  ns <- NS(id)
  tagList(

    highchartOutput(ns("chart1")),

    hr(),

    fluidRow(
      column(6,
             tags$h3("Country: "),
             pickerInput(
               inputId = ns("location"),
               choices = sort(unique(oecd_kei_unempl_rate$location)),
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
      column(6,
             tags$h3("Indicator:"),
             pickerInput(
               inputId = ns("subject"),
               choices = sort(unique(oecd_kei_unempl_rate$subject)),
               selected = sort(unique(oecd_kei_unempl_rate$subject))[1],
               multiple = F
             ),
      )
    )
  )
}

#' oecd_kei_unempl_rate Server Functions
#'
#' @noRd
mod_oecd_kei_unempl_rate_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    df_filtered <- reactive({
      oecd_kei_unempl_rate |>
        dplyr::filter(.data$location %in% input$location) |>
        dplyr::filter(.data$subject %in% input$subject)
    })
    output$chart1 <- renderHighchart({
      data = df_filtered()
      hc <- data |>
        hchart("line", hcaes(x = .data$obs_time,
                             y = .data$obs_value,
                             group = .data$location)) |>
        hc_xAxis(title = list(text = ""),
                 type = 'datetime',
                 plotBands = us_recessions) |>
        hc_yAxis(title = list(text = input$subject),
                 labels = list(format = '{value}%')) |>
        hc_subtitle(text = '* Pct. change from previous year',
                    align = 'right',
                    x = -40
        )
      hc
    })
  })
}

## To be copied in the UI
# mod_oecd_kei_unempl_rate_ui("oecd_kei_unempl_rate_ui_1")

## To be copied in the server
# mod_oecd_kei_unempl_rate_server("oecd_kei_unempl_rate_ui_1")
