#' mod_redfin UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom rlang .data
mod_redfin_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      highchartOutput(ns("chart1")),

      hr(),

      fluidRow(
        column(6,
               tags$h3("Property Type: "),
               pickerInput(
                 inputId = ns("property_type"),
                 choices = sort(unique(redfin$property_type)),
                 selected = "all_residential",
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
               tags$h3("Name: "),
               pickerInput(
                 inputId = ns("name"),
                 choices = sort(unique(redfin$name)),
                 selected = sort(unique(redfin$name))[1],
                 multiple = F
               )
        )
      )
    )
  )
}

#' mod_redfin Server Functions
#'
#' @noRd
mod_redfin_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    df_filtered <- reactive({
      redfin |>
        dplyr::filter(.data$property_type %in% input$property_type) |>
        dplyr::filter(.data$name %in% input$name)
    })
    output$chart1 <- renderHighchart({
      data = df_filtered()
      hc <- data |>
        hchart("line", hcaes(x = .data$date,
                             y = .data$value,
                             group = .data$property_type,
        )) |>
        hc_xAxis(plotBands = us_recessions) |>
        hc_yAxis(title = list(text = input$name))
      hc
    })
  })
}

## To be copied in the UI
# mod_redfin_ui("redfin_ui_1")

## To be copied in the server
# mod_redfin_server("redfin_ui_1")
