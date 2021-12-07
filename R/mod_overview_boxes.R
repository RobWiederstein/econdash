#' overview_boxes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_overview_boxes_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      tags$h2("General"),
      tags$hr()
    ),
    fluidRow(class = "myrow",
             # A static infoBox
             valueBox('$23T',
                      "Largest economy: China",
                      icon = icon("dollar-sign"),
                      width = 3,
                      color = "light-blue"),
             valueBox("58,298",
                      "Per Capita GDP: USA",
                      icon = icon("dollar-sign"),
                      width = 3,
                      color = "light-blue"),
             valueBox("6.2%",
                      "Infl. all item: USA",
                      icon = icon("percent"),
                      width = 3,
                      color = "light-blue"),
             valueBox("4.6%",
                      "Oct. monthly unemployment rate: USA",
                      icon = icon("percent"),
                      width = 3,
                      color = "light-blue")
    ),
    fluidRow(
      tags$h2("Housing"),
      tags$hr()
    ),
    fluidRow(class = "myrow",
             # A static infoBox
             valueBox("271",
                      "Case-Shiller Home Price Idx.",
                      icon = icon("credit-card"),
                      width = 3,
                      color = "light-blue")
    ),
    fluidRow(
      tags$h2("Leading"),
      tags$hr()
    ),
    fluidRow(class = "myrow",
             # A static infoBox
             valueBox("7.65",
                      "Weekly Economic Idx.",
                      icon = icon("credit-card"),
                      width = 3,
                      color = "light-blue")
    ),
    fluidRow(
      tags$h2("Sentiment"),
      tags$hr()
    ),
    fluidRow(class = "myrow",
             # A static infoBox
             valueBox("72.8",
                      "Consumer Sentiment.",
                      icon = icon("credit-card"),
                      width = 3,
                      color = "light-blue")
    ),
    fluidRow(
      tags$h2("Stocks"),
      tags$hr()
    ),
    fluidRow(class = "myrow",
             # A static infoBox
             valueBox("194%",
                      "U.S. Stock Mkt. to GDP",
                      icon = icon("credit-card"),
                      width = 3,
                      color = "light-blue")
    ),
    tags$head(tags$style(HTML(".small-box {height: 150px}")))
  )
}

#' overview_boxes Server Functions
#'
#' @noRd
mod_overview_boxes_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$gdp_total <- renderText({
      x <- 12
      x
    })

  })
}

## To be copied in the UI
# mod_overview_boxes_ui("overview_boxes_ui_1")

## To be copied in the server
# mod_overview_boxes_server("overview_boxes_ui_1")
