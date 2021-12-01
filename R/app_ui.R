#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny  shinydashboard
#' @importFrom shinydashboardPlus accordion
#' @importFrom shinydashboardPlus accordionItem

#' @noRd


## ................................................................
##                            header                             .
## ................................................................

header <- shinydashboardPlus::dashboardHeader(
  title = "Economic Dashboard"
)

## ................................................................
##                          left-sidebar                         .
## ................................................................

left_sidebar <- shinydashboardPlus::dashboardSidebar(
  shinydashboard::sidebarMenu(
    # Setting id makes input$tabs give the tabName of currently-selected tab
    id = "tabs",
    shinydashboard::menuItem("General",
      tabName = "general", icon = icon("chart-line"),
      menuSubItem("GDP total", tabName = "gdp_total", icon = icon("chart-line")),
      menuSubItem("GDP per capita", tabName = "gdp_per_capita", icon = icon("chart-line")),
      menuSubItem("Inflation", tabName = "inflation", icon = icon("chart-line")),
      menuSubItem("Unemployment", tabName = "unemployment", icon = icon("chart-line"))
    ),
    shinydashboard::menuItem("Housing",
      tabName = "housing", icon = icon("home"),
      menuSubItem("Housing Price Idx", tabName = "hpi", icon = icon("home"))
    ),
    shinydashboard::menuItem("Leading",
      tabName = "leading", icon = icon("chart-line"),
      menuSubItem("WEI", tabName = "wei", icon = icon("chart-line"))
    ),
    shinydashboard::menuItem("Sentiment",
      tabName = "sentiment", icon = icon("thermometer"),
      menuSubItem("U. of Mich.", "uofm", icon = icon("thermometer"))
    )
  )
)

## ................................................................
##                            footer                             .
## ................................................................

footer <- shinydashboardPlus::dashboardFooter(
  left = "Rob Wiederstein",
  right = HTML('<a href="https://github.com/RobWiederstein/econdash/blob/main/LICENSE.md">MIT License 2021</a>')
)

## ................................................................
##                        user-interface                         .
## ................................................................

app_ui <- function(request) {
  tagList(
    # external resources ----
    golem_add_external_resources(),
    # begin UI ----
    shinydashboardPlus::dashboardPage(
      skin = "blue",
      md = TRUE,
      ## header (see above) ----
      header = header,
      ## left sidebar (see above) ----
      sidebar = left_sidebar,
      ## body ----
      body = dashboardBody(
        tabItems(
          ### general  ----
          tabItem(tabName = "general", "general"),
          #### gdp total ----
          tabItem(
            tabName = "gdp_total",
            fluidRow(
              shinydashboardPlus::box(
                title = "OECD GDP total",
                width = 12,
                status = "primary",
                collapsible = TRUE,
                collapsed = F,
                mod_gdp_total_ui("gdp_total_ui_1"),
                accordion(
                  id = "gdp_total",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("The S&P CoreLogic Case-Shiller U.S. National Home Price NSA Index is a composite of
                                        single-family home price indices for the nine U.S. Census divisions
                                        and is calculated monthly. The index seeks to measure changes in
                                        the total value of all existing single-family housing stock. Additional
                                        informat <a href='https://bit.ly/3klOFdK'>here</a>.")
                  )
                )
              )
            )
          ),
          #### gdp per capita ----
          tabItem(
            tabName = "gdp_per_capita",
            fluidRow(
              shinydashboardPlus::box(
                title = "OECD GDP Per Capita",
                width = 12,
                status = "primary",
                collapsible = TRUE,
                collapsed = F,
                mod_gdp_per_capita_ui("gdp_per_capita_ui_1"),
                accordion(
                  id = "gdp_total",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("The S&P CoreLogic Case-Shiller U.S. National Home Price NSA Index is a composite of
                                        single-family home price indices for the nine U.S. Census divisions
                                        and is calculated monthly. The index seeks to measure changes in
                                        the total value of all existing single-family housing stock. Additional
                                        informat <a href='https://bit.ly/3klOFdK'>here</a>.")
                  )
                )
              )
            )
          ),
          #### inflation ----
          tabItem(
            tabName = "inflation",
            fluidRow(
              shinydashboardPlus::box(
                title = "OECD Inflation Prices",
                width = 12,
                status = "primary",
                collapsible = TRUE,
                collapsed = F,
                mod_oecd_prices_cpi_ui("oecd_prices_cpi_ui_1"),
                accordion(
                  id = "gdp_total",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("The S&P CoreLogic Case-Shiller U.S. National Home Price NSA Index is a composite of
                                        single-family home price indices for the nine U.S. Census divisions
                                        and is calculated monthly. The index seeks to measure changes in
                                        the total value of all existing single-family housing stock. Additional
                                        informat <a href='https://bit.ly/3klOFdK'>here</a>.")
                  )
                )
              )
            )
          ),
          #### unemployment ----
          tabItem(tabName = "unemployment", "unemployment"),
          ### housing  ----
          tabItem(tabName = "housing", "housing"),
          #### Case-Shiller National Housing Price Index ----
          tabItem(
            tabName = "hpi",
            fluidRow(
              shinydashboardPlus::box(
                title = "Case-Shiller U.S. National Home Price Index
                                (CSUSHPINSA)",
                width = 12,
                status = "primary",
                collapsible = TRUE,
                collapsed = F,
                mod_csushpinsa_ui("csushpinsa_ui_1"),
                accordion(
                  id = "acc_csushpinsa",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("The S&P CoreLogic Case-Shiller U.S. National Home Price NSA Index is a composite of
                                        single-family home price indices for the nine U.S. Census divisions
                                        and is calculated monthly. The index seeks to measure changes in
                                        the total value of all existing single-family housing stock. Additional
                                        informat <a href='https://bit.ly/3klOFdK'>here</a>.")
                  )
                )
              )
            )
          ),
          ### leading ----
          tabItem(tabName = "leading", "leading"),
          #### weekly economic index ----
          tabItem(
            tabName = "wei",
            fluidRow(
              shinydashboardPlus::box(
                title = "Weekly Economic Index (WEI)",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_wei_ui("wei_ui_1"),
                accordion(
                  id = "accordion1",
                  accordionItem(
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:16px'>The WEI is an index of ten indicators of real economic
                                         activity, scaled to align with the four-quarter GDP
                                         growth rate. It represents the common component of
                                         series covering consumer behavior, the labor market,
                                         and production. Additional information <a href='https://nyfed.org/3obE6uP'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          ### sentiment  ----
          tabItem(tabName = "sentiment", "sentiment"),
          #### umcsent ----
          tabItem(
            tabName = "uofm",
            fluidRow(
              shinydashboardPlus::box(
                title = "Univ. of Mich. Consumer Sentiment Survey (UMCSENT)",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_umcsent_ui("umcsent_ui_1"),
                accordion(
                  id = "acc_umcsent",
                  accordionItem(
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:16px'>Founded in 1946 and performed by the
                                             University of Michigan, the Survey of Consumers gives insight as
                                             to consumer and spending decisions.  The survey's ability to
                                             predict consumer behavior led to its inclusion in the Leading
                                             Indicator Composite Index, published by the Bureau of Economic
                                             Analysis (BEA) and the U.S. Department of Commerce. The series
                                             is one month behind at the author's request.  Additional
                                             information
                                             <a href='https://data.sca.isr.umich.edu/fetchdoc.php?docid=24774'>here</a>.</p>")
                  )
                )
              )
            )
          )
          ## end body ----
        )
      ),
      ## footer ----
      footer = footer
    )
    # end UI ----
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd

golem_add_external_resources <- function() {
  add_resource_path(
    "www", app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "econdash"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
