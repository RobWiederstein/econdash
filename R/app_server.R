#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  #overview
  mod_overview_boxes_server("overview_boxes_ui_1")
  # general
  mod_gdp_total_server("gdp_total_ui_1")
  mod_gdp_per_capita_server("gdp_per_capita_ui_1")
  mod_oecd_kei_unempl_rate_server("oecd_kei_unempl_rate_ui_1")
  mod_oecd_prices_cpi_server("oecd_prices_cpi_ui_1")
  # housing
  mod_csushpinsa_server("csushpinsa_ui_1")
  mod_redfin_server("redfin_ui_1")
  # leading
  mod_wei_server("wei_ui_1")
  # sentiment
  mod_umcsent_server("umcsent_ui_1")
  # stocks
  mod_wb_wdi_mkt_cap_server("wb_wdi_mkt_cap_ui_1")
}
