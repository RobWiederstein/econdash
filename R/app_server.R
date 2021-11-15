#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic
	mod_wei_server("wei_ui_1")
	mod_umcsent_server("umcsent_ui_1")
	mod_csushpinsa_server("csushpinsa_ui_1")
}