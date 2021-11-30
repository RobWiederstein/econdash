#' oecd_prices_cpi UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom rlang .data
mod_oecd_prices_cpi_ui <- function(id) {
  ns <- NS(id)
  tagList(
    highchartOutput(NS(id, "chart1")),
    hr(),
    fluidRow(
      column(
        6,
        pickerInput(
          inputId = NS(id, "location"),
          label = "Location: ",
          choices = sort(unique(oecd_prices_cpi$location)),
          selected = c("USA", "G-20"),
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
        pickerInput(
          inputId = NS(id, "subject"),
          label = "Subject:",
          choices = sort(unique(oecd_prices_cpi$names)),
          selected = sort(unique(oecd_prices_cpi$names))[1],
          multiple = F
        )
      )
    )
  )
}

#' oecd_prices_cpi Server Functions
#'
#' @noRd
mod_oecd_prices_cpi_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    df_filtered <- reactive({
      oecd_prices_cpi |>
        dplyr::filter(.data$location %in% input$location) |>
        dplyr::filter(.data$names %in% input$subject)
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
# mod_oecd_prices_cpi_ui("oecd_prices_cpi_ui_1")

## To be copied in the server
# mod_oecd_prices_cpi_server("oecd_prices_cpi_ui_1")
