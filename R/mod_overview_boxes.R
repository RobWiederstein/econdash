#' overview_boxes UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom shinydashboard valueBox renderValueBox valueBoxOutput updateTabItems
#' @importFrom rlang .data
mod_overview_boxes_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      tags$h2("General:"), # general ----
      tags$hr()
    ),
    ## gdp total ----
    fluidRow(
      class = "myrow",
      valueBoxOutput(ns("gdp_total"), width = 3),
    ## gdp per capita ----
      shinydashboard::valueBox("58,298",
        "Per Capita GDP: USA",
        icon = icon("dollar-sign"),
        width = 3,
        color = "blue"
      ),
      valueBox("6.2%",
        "Infl. all item: USA",
        icon = icon("percent"),
        width = 3,
        color = "blue"
      ),
      valueBox("4.6%",
        "Oct. monthly unemployment rate: USA",
        icon = icon("percent"),
        width = 3,
        color = "blue"
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
        color = "blue"
      ),
      valueBox("387,271",
        "Median Sale Price",
        icon = icon("dollar-sign"),
        width = 3,
        color = "blue"
      ),
      valueBox("3.55",
        "30 Year Fixed Mortgage Rate",
        icon = icon("percent"),
        width = 3,
        color = "blue"
      ),
      valueBox("1.7 million",
        "Total Housing Units Started",
        icon = icon("percent"),
        width = 3,
        color = "blue"
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
        color = "blue"
      ),
      valueBox("-.195",
        "ADS Business Conditions Index",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      ),
      valueBox("14.4%",
        "Recession Probability - Yield Curve",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      ),
      valueBox("1.82%",
        "Recession Probability - Chavet & Piger",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
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
        color = "blue"
      ),
      valueBox("65%",
        "Individuals Expecting Gain in Dow",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      ),
      valueBox("-17.5%",
        "AAII Bull (+) / Bear (-) Spread",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      ),
      valueBox("27.66",
        "VIX Fear Gauge",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
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
        color = "blue"
      ),
      valueBox(HTML("<i class='fas fa-caret-down'>37.6</i>"),
        "Shiller PE Ratio",
        icon = icon("credit-card"),
        width = 3,
        color = "blue",
        href = "https://www.google.com"
      ),
      valueBox("$444 Billion",
        "FINRA Net Margin Debt",
        icon = icon("arrow-down"),
        width = 3,
        color = "blue"
      )
    ),
    tags$head(tags$style(HTML(".small-box {height: 150px}")))
  )
}

#' overview_boxes Server Functions
#'
#' @noRd
#  server ----
mod_overview_boxes_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    ## gdp total ----
    output$gdp_total <- renderValueBox({
      usa_latest_change <-
        oecd_gdp_total |>
          dplyr::arrange(obs_time) |>
          dplyr::filter(location == 'USA') |>
          dplyr::slice_tail(n = 2) |>
          dplyr::select(obs_time, location, obs_value) |>
          dplyr::rename(date = obs_time, value = obs_value)
      usa_latest_gdp <-
        usa_latest_change |>
          dplyr::slice(which.max(usa_latest_change$date)) |>
          dplyr::pull(value) |>
          round(1)
      value = actionLink(
        inputId = "gdpTotalLink",
        label = div(paste0('$', usa_latest_gdp, "T")), style = "color: white")
      subtitle = HTML(paste0('USA GDP: ',
                             chg2pct(usa_latest_change),
                             "% <br/>",
                             'Last: ',
                             max(usa_latest_change$date)))
      icon = if(chg2pct(usa_latest_change) > 0){
        icon('arrow-up')
      }else if(chg2pct(usa_latest_change) < 0){
        icon('arrow-down')
      }else{
        icon('arrows-h')
      }
      valueBox(value = value,
               subtitle = subtitle,
               icon = icon,
               color = "blue"
      )
    })
  })
}

## To be copied in the UI
# mod_overview_boxes_ui("overview_boxes_ui_1")

## To be copied in the server
# mod_overview_boxes_server("overview_boxes_ui_1")
