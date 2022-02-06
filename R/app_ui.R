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
  title = "U.S. Economic Dashboard"
)

## ................................................................
##                          left-sidebar                         .
## ................................................................

left_sidebar <- shinydashboardPlus::dashboardSidebar(
  shinydashboard::sidebarMenu(
    # Setting id makes input$tabs give the tabName of currently-selected tab
    id = "tabs",
    #overview
    shinydashboard::menuItem("Overview", tabName = "overview", icon = icon("table")),
    #general
    shinydashboard::menuItem("General", tabName = "general", icon = icon("chart-line"),
      menuSubItem("GDP total", tabName = "gdp_total", icon = icon("chart-line")),
      menuSubItem("GDP per capita", tabName = "gdp_per_capita", icon = icon("chart-line")),
      menuSubItem("Inflation", tabName = "inflation", icon = icon("chart-line")),
      menuSubItem("Unemployment", tabName = "unemployment", icon = icon("chart-line"))
    ),
    shinydashboard::menuItem("Housing",
      tabName = "housing", icon = icon("home"),
      menuSubItem("Housing Price Idx", tabName = "hpi", icon = icon("home")),
      menuSubItem("Redfin Housing Data", tabName = "rhd", icon = icon("home")),
      menuSubItem("Mortgage Rates", tabName = "mr", icon = icon("home")),
      menuSubItem("Housing Starts", tabName = "houst", icon = icon("home"))
    ),
    shinydashboard::menuItem("Leading",
      tabName = "leading", icon = icon("binoculars"),
      menuSubItem("Weekly Econ Indicators", tabName = "wei", icon = icon("binoculars")),
      menuSubItem("ADS Business Conditions", tabName = "ads", icon = icon("binoculars")),
      menuSubItem("Treasury Yield Curve", tabName = "tyc", icon = icon("binoculars")),
      menuSubItem("Piger Recession Probability", tabName = "prp", icon = icon("binoculars"))
    ),
    shinydashboard::menuItem("Sentiment",
      tabName = "sentiment", icon = icon("thermometer"),
      menuSubItem("Consumer Sentiment", "umcs", icon = icon("thermometer")),
      menuSubItem("Investor Confidence", "ymic", icon = icon("thermometer")),
      menuSubItem("AAII Investor Sentiment", "aaii", icon = icon("thermometer")),
      menuSubItem("Volatility", "vix", icon = icon("thermometer"))
    ),
    shinydashboard::menuItem("Stocks",
                             tabName = "stocks", icon = icon("dollar-sign"),
                             menuSubItem("Mkt. Cap % of GDP", "mktcap", icon = icon("dollar-sign")),
                             menuSubItem("Shiller PE Ratio", "sper", icon = icon("dollar-sign"))
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
          ### overview ----
          tabItem(tabName = "overview",
                  mod_overview_boxes_ui("overview_boxes_ui_1")
                ),
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
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>According to the OECD, 'Gross domestic product (GDP) is the standard measure
                    of the value added created through the production of goods and services in
                    a country during a certain period.' Additional information <a href='https://bit.ly/3klOFdK'>here</a>.</p>")
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
                  id = "gdp_per_capita",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>Per capita GDP is a global measure for gauging the prosperity of nations and is used by
                         economists, along with GDP, to analyze the prosperity of a country based on its
                         economic growth.</p>")
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
                  id = "inflation",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>According to the OECD, 'Inflation measured by consumer price index (CPI) is
                         defined as the change in the prices of a basket of goods and services that
                         are typically purchased by specific groups of households.' The US central bank,
                         Federal Reserve, emphasizes core inflation that excludes more volatile food and
                         energy prices. Additional information <a href='https://bit.ly/3rFD0uF'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          #### unemployment ----
          tabItem(
            tabName = "unemployment",
            fluidRow(
              shinydashboardPlus::box(
                title = "OECD Unemployment Rate",
                width = 12,
                status = "primary",
                collapsible = TRUE,
                collapsed = F,
                mod_oecd_kei_unempl_rate_ui("oecd_kei_unempl_rate_ui_1"),
                accordion(
                  id = "unemployment",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>According to the OECD, ' This indicator is measured in numbers of unemployed people as
                    a percentage of the labour force and it is seasonally adjusted.' Additional
                                        information <a href='https://bit.ly/3pyjs8T'>here</a>.</p>")
                  )
                )
              )
            )
          ),
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
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>The S&P CoreLogic Case-Shiller U.S. National Home Price NSA Index is a composite of
                                        single-family home price indices for the nine U.S. Census divisions
                                        and is calculated monthly. The index seeks to measure changes in
                                        the total value of all existing single-family housing stock. Additional
                                        information. <a href='https://bit.ly/3klOFdK'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          #### Redfin Housing Data ----
          tabItem(
            tabName = "rhd",
            fluidRow(
              shinydashboardPlus::box(
                title = "Redfin National Housing Data",
                width = 12,
                status = "primary",
                collapsible = TRUE,
                collapsed = F,
                mod_redfin_ui("redfin_ui_1"),
                accordion(
                  id = "acc_rhd",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>The S&P CoreLogic Case-Shiller U.S. National Home Price NSA Index is a composite of
                                        single-family home price indices for the nine U.S. Census divisions
                                        and is calculated monthly. The index seeks to measure changes in
                                        the total value of all existing single-family housing stock. Additional
                                        information. <a href='https://bit.ly/3klOFdK'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          #### Mortgage Rates - Freddie Mac ----
          tabItem(
            tabName = "mr",
            fluidRow(
              shinydashboardPlus::box(
                title = "Mortgage Rates - Freddie Mac",
                width = 12,
                status = "primary",
                collapsible = TRUE,
                collapsed = F,
                mod_fmac_mortgage_rates_ui("fmac_mortgage_rates_ui_1"),
                accordion(
                  id = "acc_mr",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>
                    Lenders are surveyed weekly on mortgage rates on popular
                    loans. The survey is based on first - lien prime conventional
                    conforming home purchase mortgages with a loan - to - value
                    of 80 percent. Lenders are comprised of thrifts, credit unions,
                    commercial banks and mortgage lending companies. Additional
                    information <a href='http://www.freddiemac.com/pmms'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          #### Housing Starts (HOUST) ----
          tabItem(
            tabName = "houst",
            fluidRow(
              shinydashboardPlus::box(
                title = "Total U.S. Housing Starts",
                width = 12,
                status = "primary",
                collapsible = TRUE,
                collapsed = F,
                mod_fred_housing_starts_ui("fred_housing_starts_ui_1"),
                accordion(
                  id = "acc_houst",
                  accordionItem(
                    title =  HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>
                    The U.S. Census defines a 'start' as occurring when excavation begins
                    for the footings or foundation of a building. All housing units in a
                    multifamily building are defined as being started when this excavation
                    begins. Beginning with data for September 1992, estimates of housing
                    starts include units in structures being totally rebuilt on an existing
                    foundation. Additional information
                    <a href='https://www.census.gov/construction/nrc/index.html'>here</a>.</p>")
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
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>The WEI is an index of ten indicators of real economic
                                         activity, scaled to align with the four-quarter GDP
                                         growth rate. It represents the common component of
                                         series covering consumer behavior, the labor market,
                                         and production. The WEI is composed of ten underlying
                         series: (1) the Redbook same-store retail sales index, (2) the Rasmussen Consumer
                         Index, (3) the continuing unemployment insurance claims, (4) the American Staffing
                         Association Index of temporary and contract employment, (5) federal tax withholding
                         data, (6) new unemployment insurance claims, (7) U.S. steel production, (8) U.S.
                         electricity output, (9) fuel sales (10) total railroad traffic. Additional
                         information <a href='https://nyfed.org/3obE6uP'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          #### Aruoba-Diebold-Scotti Business Conditions Index ----
          tabItem(
            tabName = "ads",
            fluidRow(
              shinydashboardPlus::box(
                title = "ADS Business Conditions",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_pfed_ads_bus_conditions_ui("pfed_ads_bus_conditions_ui_1"),
                accordion(
                  id = "acc_ads",
                  accordionItem(
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>According to the Philadelphia Federal
                    Reserve, 'the Aruoba-Diebold-Scotti business conditions
                    index is designed to track real business conditions at high observation
                    frequency. The index uses the following economic indicators: weekly initial
                    jobless claims, monthly payroll employment, monthly industrial production,
                    monthly real personal income less transfer payments, monthly real manufacturing
                    and trade sales; and quarterly real GDP. The average value of the ADS index is
                    zero. Progressively bigger positive values indicate progressively
                    better-than-average conditions, whereas progressively more negative values
                    indicate progressively worse-than-average conditions.' Additional
                    information <a href='https://bit.ly/3ubFa6o'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          #### New York Fed Treasury Yield Curve ----
          tabItem(
            tabName = "tyc",
            fluidRow(
              shinydashboardPlus::box(
                title = "Treasury Yield Curve",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_nyfed_yield_spread_ui("nyfed_yield_spread_ui_1"),
                accordion(
                  id = "acc_tyc",
                  accordionItem(
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>According to the New York Fed, 'this model uses the
                    slope of the yield curve, or 'term spread,' to calculate the probability of a recession
                    in the United States twelve months ahead. Here, the term spread is defined as the
                    difference between 10-year and 3-month Treasury rates.'  One article notes that the yield
                    curve is simple to use and significantly outperforms other indicators when looking
                    two to six quarters ahead. Additional information <a href='https://nyfed.org/3sfJ0Js'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          #### Piger Recession Probability ----
          tabItem(
            tabName = "prp",
            fluidRow(
              shinydashboardPlus::box(
                title = "Piger Recession Probability",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_fred_piger_rec_prob_ui("fred_piger_rec_prob_ui_1"),
                accordion(
                  id = "acc_prp",
                  accordionItem(
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>According to Jeremy Piger, the 'monthly
                         smoothed recession probabilities are calculated from a dynamic-factor
                         Markov-switching (DFMS) model applied to four monthly coincident
                         variables: non-farm payroll employment, the index of industrial
                         production, real personal income excluding transfer payments, and
                         real manufacturing and trade sales.'
                         <br/>
                         <br/>
                         For interpretation, 'three
                         consecutive months of smoothed probabilities above 80% has been a
                         reliable signal of the start of a new recession, while three consecutive
                         months of smoothed probabilities below 20% has been a reliable signal
                         of the start of a new expansion.' Additional information
                         <a href='https://bit.ly/3rkGvpZ'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          ### sentiment  ----
          tabItem(tabName = "sentiment", "sentiment"),
          #### U of Mich Consumer Sentiment ----
          tabItem(
            tabName = "umcs",
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
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>Founded in 1946 and performed by the
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
          ),
          #### Yale Mgmt Investor Sentiment ----
          tabItem(
            tabName = "ymic",
            fluidRow(
              shinydashboardPlus::box(
                title = "Yale Management Investor Confidence Survey",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_yale_inv_conf_survey_ui("yale_inv_conf_survey_ui_1")
              )
            )
          ),
          #### AAII Investor Sentiment ----
          tabItem(
            tabName = "aaii",
            fluidRow(
              shinydashboardPlus::box(
                title = "AAII Investor Sentiment",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_aaii_inv_sentiment_ui("aaii_inv_sentiment_ui_1")
              )
            )
          ),
          #### vix ----
          tabItem(
            tabName = "vix",
            fluidRow(
              shinydashboardPlus::box(
                title = "VIX -- Market Volatility Indicator",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_cboe_vix_ui("cboe_vix_ui_1"),
                accordion(
                  id = "acc_vix",
                  accordionItem(
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>Commonly known as the <i>fear index</i> or <i> fear
                    gauge </i>, the VIX is published by the Chicago Board of Exchange. According to the CBOE,
                    'The VIX Index is a calculation designed
                    to produce a measure of constant, 30-day expected volatility of the U.S. stock market, derived
                    from real-time, mid-quote prices of S&P 500 Index (SPX) call and put options. On a global basis,
                    it is one of the most recognized measures of volatility -- widely reported by financial media
                    and closely followed by a variety of market participants as a daily market indicator.'
                    Additional information <a href='https://www.cboe.com/tradable_products/vix/'>here</a>.</p>")
                  )
                )
              )
            )
          ),
          ### stocks  ----
          tabItem(tabName = "stocks", "stocks"),
          #### mktcap ----
          tabItem(
            tabName = "mktcap",
            fluidRow(
              shinydashboardPlus::box(
                title = "Market Cap as % of GDP",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_wb_wdi_mkt_cap_ui("wb_wdi_mkt_cap_ui_1"),
                accordion(
                  id = "acc_mktcap",
                  accordionItem(
                    title = HTML('<i class="fa fa-info-circle fa-xs" style="color:#2196f3" aria-hidden="true"></i>'),
                    # status = "success",
                    collapsed = TRUE,
                    HTML("<p style='font-size:20px'>The numerator is the total market capitalization and calculated by
                    multiplying the share price by the number of shares outstanding for listed domestic companies. The
                    denominator is the country's GDP.The measure is sometimes referred to as the 'Buffet Indicator' after
                    famed US investor Warren Buffet.
                    Additional information <a href='https://data.worldbank.org/indicator/CM.MKT.LCAP.GD.ZS'>here</a>.</p>")
                  )
                )
              )
            )
          ),#### shiller ----
          tabItem(
            tabName = "sper",
            fluidRow(
              shinydashboardPlus::box(
                title = "Shiller PE Ratio",
                width = 12,
                status = "primary",
                collapsible = T,
                collapsed = F,
                mod_shiller_pe_ratio_ui("shiller_pe_ratio_ui_1")
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
