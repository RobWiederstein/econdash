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
      valueBoxOutput(ns("gdp_per_capita"), width = 3),
    ## inflation ----
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
    # households ----
    fluidRow(
      tags$h2("Households"),
      tags$hr()
    ),
    ## avg consumer debt ----
    fluidRow(
      class = "myrow",
      valueBox("$44,000",
               "Average consumer debt",
               icon = icon("credit-card"),
               width = 3,
               color = "blue"
      )
    ),
    # housing ----
    fluidRow(
      tags$h2("Housing"),
      tags$hr()
    ),
    ## case-shiller ----
    fluidRow(
      class = "myrow",
      valueBox("271",
        "Case-Shiller Home Price Idx.",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      ),
    ## median sale price ----
      valueBox("387,271",
        "Median Sale Price",
        icon = icon("dollar-sign"),
        width = 3,
        color = "blue"
      ),
    ## mortgage rates ----
      valueBox("3.55",
        "30 Year Fixed Mortgage Rate",
        icon = icon("percent"),
        width = 3,
        color = "blue"
      ),
    ## units started ----
      valueBox("1.7 million",
        "Total Housing Units Started",
        icon = icon("percent"),
        width = 3,
        color = "blue"
      )
    ),
    # leading ----
    fluidRow(
      tags$h2("Leading"),
      tags$hr()
    ),
    ## weekly economic idx -----
    fluidRow(
      class = "myrow",
      valueBox("7.65",
        "Weekly Economic Idx.",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      ),
    ## ADS Bus conditions ----
      valueBox("-.195",
        "ADS Business Conditions Index",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      ),
    ## yield curve ----
      valueBox("14.4%",
        "Recession Probability - Yield Curve",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      ),
    ## recession probability ----
      valueBox("1.82%",
        "Recession Probability - Chavet & Piger",
        icon = icon("credit-card"),
        width = 3,
        color = "blue"
      )
    ),
    # sentiment ----
    fluidRow(
      tags$h2("Sentiment"),
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
    # general ----
    ## gdp total ----
    output$gdp_total <- renderValueBox({
      usa_latest_change <-
        oecd_gdp_total |>
          dplyr::arrange(.data$obs_time) |>
          dplyr::filter(.data$location == 'USA') |>
          dplyr::slice_tail(n = 2) |>
          dplyr::select(.data$obs_time, .data$location, .data$obs_value) |>
          dplyr::rename(date = .data$obs_time, value = .data$obs_value)
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
      icon = insert_arrow(chg2pct(usa_latest_change))
      color = color_box(chg2pct(usa_latest_change))
      valueBox(value = value,
               subtitle = subtitle,
               icon = icon,
               color = color
      )
    })
    ## gdp per capita ----
    output$gdp_per_capita <- renderValueBox({
    ### latest change ----
      usa_latest_change <-
      oecd_gdp_per_capita |>
      dplyr::arrange(.data$obs_time) |>
      dplyr::filter(.data$location == 'USA') |>
      dplyr::slice_tail(n = 2) |>
      dplyr::select(.data$obs_time, .data$location, .data$obs_value) |>
      dplyr::rename(date = .data$obs_time, value = .data$obs_value)
    ### latest value ----
    usa_latest_gdp_per_capita <-
      usa_latest_change |>
      dplyr::slice(which.max(usa_latest_change$date)) |>
      dplyr::pull(value) |>
      round(0) |>
      format(big.mark = ",")
    ### value ----
      value = actionLink(
        inputId = "gdpPerCapitaLink",
        label = div(paste0('$', usa_latest_gdp_per_capita)), style = "color: white")
      subtitle = HTML(paste0('USA GDP Per Capita: ',
                             chg2pct(usa_latest_change),
                             "% <br/>",
                             'Last: ',
                             max(usa_latest_change$date)))
    ### icon ----
      icon = insert_arrow(chg2pct(usa_latest_change))
      color = color_box(chg2pct(usa_latest_change))
    ### value box ----
      valueBox(value = value,
               subtitle = subtitle,
               icon = icon,
               color = color
      )
    })
      # households ----
      ## consumer debt ----
      output$nyfed_qhcd <- renderValueBox({
        valueBox(value = value,
                 subtitle = subtitle,
                 icon = icon,
                 color = color
        )
      })
    })
}

## To be copied in the UI
# mod_overview_boxes_ui("overview_boxes_ui_1")

## To be copied in the server
# mod_overview_boxes_server("overview_boxes_ui_1")
