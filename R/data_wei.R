#' Weekly Economic indicators index.
#'
#' A dataset containing the weekly economic index for the U.S.
#'
#' @format A time series object where each row represents a week and 2 variables:
#'
#' \describe{
#'   \item{date}{date the index was computed}
#'   \item{value}{index value}
#' }
#'
#' @details The WEI is an index of real economic activity using timely and
#' relevant high-frequency data. It represents the common component of ten
#' different daily and weekly series covering consumer behavior, the labor
#' market, and production. The WEI is scaled to the four-quarter GDP growth
#' rate; for example, if the WEI reads -2 percent and the current level of
#' the WEI persists for an entire quarter, we would expect, on average, GDP
#' that quarter to be 2 percent lower than a year previously.
#'
#' @source \url{http://www.diamondse.info/}
"wei"
