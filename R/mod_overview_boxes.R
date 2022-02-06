#' overview_boxes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom shinydashboard valueBox
mod_overview_boxes_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      tags$h2("General"), # general ----
      tags$hr()
    ),
    fluidRow(
      class = "myrow",
      tags$a(
        href = "https://www.google.com/", # Link to open
        target = "_blank", # Open in new window
        valueBox("$23T",
          "Largest economy: China",
          icon = icon("dollar-sign"),
          width = 3,
          color = "light-blue"
        )
      ),
      valueBox("58,298",
        "Per Capita GDP: USA",
        icon = icon("dollar-sign"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("6.2%",
        "Infl. all item: USA",
        icon = icon("percent"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("4.6%",
        "Oct. monthly unemployment rate: USA",
        icon = icon("percent"),
        width = 3,
        color = "light-blue"
      )
    ),
    fluidRow(
      tags$h2("Housing"), # housing ----
      tags$hr()
    ),
    fluidRow(
      class = "myrow",
      valueBox("271",
        "Case-Shiller Home Price Idx.",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("387,271",
        "Median Sale Price",
        icon = icon("dollar-sign"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("3.55",
        "30 Year Fixed Mortgage Rate",
        icon = icon("percent"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("1.7 million",
        "Total Housing Units Started",
        icon = icon("percent"),
        width = 3,
        color = "light-blue"
      )
    ),
    fluidRow(
      tags$h2("Leading"), # leading ----
      tags$hr()
    ),
    fluidRow(
      class = "myrow",
      valueBox("7.65",
        "Weekly Economic Idx.",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("-.195",
        "ADS Business Conditions Index",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("14.4%",
        "Recession Probability - Yield Curve",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("1.82%",
        "Recession Probability - Chavet & Piger",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      )
    ),
    fluidRow(
      tags$h2("Sentiment"), # sentiment ----
      tags$hr()
    ),
    fluidRow(
      class = "myrow",
      valueBox("72.8",
        "Consumer Sentiment",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("65%",
        "Individuals Expecting Gain in Dow",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("-17.5%",
        "AAII Bull (+) / Bear (-) Spread",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      ),
      valueBox("27.66",
        "VIX Fear Gauge",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      )
    ),
    fluidRow(
      tags$h2("Stocks"), # stocks ----
      tags$hr()
    ),
    fluidRow(
      class = "myrow",
      valueBox("194%",
        "U.S. Stock Mkt. to GDP",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue"
      ),
      valueBox(HTML("<i class='fas fa-caret-down'>37.6</i>"),
        "Shiller PE Ratio",
        icon = icon("credit-card"),
        width = 3,
        color = "light-blue",
        href = "https://www.google.com"
      )
    ),
    tags$head(tags$style(HTML(".small-box {height: 150px}")))
  )
}

#' overview_boxes Server Functions
#'
#' @noRd
mod_overview_boxes_server <- function(id) {
  moduleServer(id, function(input, output, session) {
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
