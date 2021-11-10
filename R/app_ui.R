#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shinydashboard shinydashboardPlus
#' @noRd


##................................................................
##                            header                             .
##................................................................

header <- shinydashboard::dashboardHeader(
    title = "Economic Dashboard"
)

##................................................................
##                          left-sidebar                         .
##................................................................

left_sidebar <- shinydashboardPlus::dashboardSidebar(
    shinydashboard::sidebarMenu(
        # Setting id makes input$tabs give the tabName of currently-selected tab
        id = "tabs",
        shinydashboard::menuItem("Economy", tabName = "economy", icon = icon("chart-line")),
        shinydashboard::menuItem("Housing", tabName = "housing", icon = icon("home")),
        shinydashboard::menuItem("Sentiment", tabName = "sentiment", icon = icon("thermometer"))
    )
)

##................................................................
##                            footer                             .
##................................................................

footer <- shinydashboardPlus::dashboardFooter(left = "Rob Wiederstein",
                                              right = "MIT License 2021")

##................................................................
##                        user-interface                         .
##................................................................

app_ui <- function(request) {
    tagList(
        # external resources ----
        golem_add_external_resources(),
        # begin UI ----
        shinydashboardPlus::dashboardPage(
            skin = "midnight",
            md = TRUE,
            ## header (see above) ----
            header = header,
            ## left sidebar (see above) ----
            sidebar = left_sidebar,
            ## body ----
            body = dashboardBody(
                tabItems(
                    ### economy  ----
                    tabItem(
                        tabName = "economy",
                        fluidRow(
                            #### wei ----
                            box(
                                title = 'Weekly Economic Index (WEI)',
                                status = "primary",
                                collapsible = T,
                                collapsed = T,
                                mod_wei_ui("wei_ui_1"),
                                accordion(
                                    id = "accordion1",
                                    accordionItem(
                                        title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                                        #status = "success",
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
                    ### housing  ----
                    tabItem(
                        tabName = "housing",
                        fluidRow(
                            #### CSUSHPINSA ----
                            box(
                                title = "Case-Shiller U.S. National Home Price Index
                                (CSUSHPINSA)",
                                status = "primary",
                                collapsible = TRUE,
                                collapsed = TRUE,
                                mod_csushpinsa_ui("csushpinsa_ui_1"),
                                accordion(
                                    id = "acc_csushpinsa",
                                    accordionItem(
                                        title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                                        #status = "success",
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
                    ### sentiment  ----
                    tabItem(
                        tabName = "sentiment",
                        fluidRow(
                            #### umcsent ----
                            box(
                                title = 'Univ. of Mich. Consumer Sentiment Survey (UMCSENT)',
                                status = "primary",
                                collapsible = T,
                                collapsed = T,
                                mod_umcsent_ui("umcsent_ui_1"),
                                accordion(
                                    id = "acc_umcsent",
                                    accordionItem(
                                        title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#009688" aria-hidden="true"></i>'),
                                        #status = "success",
                                        collapsed = TRUE,
                                        HTML("<p style='font-size:16px'>Founded in 1946 and performed by the
                                             University of Michigan, the Survey of Consumers gives insight as
                                             to consumer and spending decisions.  The survey's ability to
                                             predict consumer behavior led to its inclusion in the Leading
                                             Indicator Composite Index, published by the Bureau of Economic
                                             Analysis (BEA) and the U.S. Department of Commerce. The series
                                             is one month behind at the author's request.  Additional
                                             information
                                             <a href='https://data.sca.isr.umich.edu/fetchdoc.php?docid=24774'>here</a>.</p>"
                                             )
                                    )
                                )
                            )
                        )
                    )
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
            app_title = "econDash"
        )
        # Add here other external resources
        # for example, you can add shinyalert::useShinyalert()
    )
}
