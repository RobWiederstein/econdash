#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  #overview ----
  mod_overview_boxes_server("overview_boxes_ui_1")
  # general ----
  mod_oecd_gdp_total_server("gdp_total_ui_1")
  mod_oecd_per_capita_server("gdp_per_capita_ui_1")
  mod_oecd_kei_unempl_rate_server("oecd_kei_unempl_rate_ui_1")
  mod_oecd_prices_cpi_server("oecd_prices_cpi_ui_1")
  # households ----
  mod_nyfed_qhdc_server("nyfed_qhdc_ui_1")
  mod_nyfed_qhdc_30_del_server("nyfed_qhdc_30_del_ui_1")
  mod_nyfed_qhdc_mo_cs_server("nyfed_qhdc_mo_cs_ui_1")
  # housing ----
  mod_csushpinsa_server("csushpinsa_ui_1")
  mod_redfin_server("redfin_ui_1")
  mod_fmac_mortgage_rates_server("fmac_mortgage_rates_ui_1")
  mod_fred_housing_starts_server("fred_housing_starts_ui_1")
  # leading ----
  mod_wei_server("wei_ui_1")
  mod_pfed_ads_bus_conditions_server("pfed_ads_bus_conditions_ui_1")
  mod_nyfed_yield_spread_server("nyfed_yield_spread_ui_1")
  mod_fred_piger_rec_prob_server("fred_piger_rec_prob_ui_1")
  # sentiment ----
  mod_umcsent_server("umcsent_ui_1")
  mod_yale_inv_conf_survey_server("yale_inv_conf_survey_ui_1")
  mod_aaii_inv_sentiment_server("aaii_inv_sentiment_ui_1")
  mod_cboe_vix_server("cboe_vix_ui_1")
  # stocks ----
  mod_wb_wdi_mkt_cap_server("wb_wdi_mkt_cap_ui_1")
  mod_shiller_pe_ratio_server("shiller_pe_ratio_ui_1")
  mod_finra_margin_debt_server("finra_margin_debt_ui_1")
  #links ----
  ##gdpTotalLink ----
  observeEvent(input$gdpTotalLink, {
    updateTabItems(session, 'tabs', 'gdp_total')
  })
  ##gdpPerCapitaLink ----
  observeEvent(input$gdpPerCapitaLink, {
    updateTabItems(session, 'tabs', 'gdp_per_capita')
  })
  ##nyfed_tot_debt----
  observeEvent(input$nyfed_tot_debt, {
    updateTabItems(session, 'tabs', 'nyfed_tot_debt')
  })
  ##nyfed_30_del----
  observeEvent(input$nyfed_30_del, {
    updateTabItems(session, 'tabs', 'nyfed_30_del')
  })
  ##nyfed_30_del----
  observeEvent(input$nyfed_mo_cs, {
    updateTabItems(session, 'tabs', 'nyfed_mo_sc')
  })
}
