#' Convert last two values in a series and convert them to a percent
#' increase or decrease
#'
#' Takes a column named 'date' and column named 'value' of a dataframe,
#' arranges the values by date, and computes the percentage change.
#'
#' @param df a dataframe
#'
#' @details dataframe must have at least two columns: one named 'date' and the
#'   other named 'value'.
#'
#' @return The percentage change over the last two time periods.
#'
#' @examples
#' \dontrun{
#' chg2pct(pos_data_set)
#' chg2pct(neg_data_set)
#' # fail
#' chg2pct("a")
#' chg2pct(data.frame(a = c(1, 2)))
#' chg2pct(data.frame(a = 1, b = 1))
#' chg2pct(data.frame(a = c(1, 2), b = c(1, 2)))
#' }
chg2pct <- function(df) {
	assertive::assert_is_data.frame(df)
	assertive::assert_all_are_true(ncol(df) >= 2 && nrow(df) >= 2)
	assertive::assert_all_are_true(c("date", "value") %in% colnames(df))
	assertive::assert_is_date(df$date)
	assertive::assert_is_numeric(df$value)
	next_to_last <-
		df |>
		dplyr::arrange(date) |>
		dplyr::slice_tail(n = 2) |>
		dplyr::pull(.data$value) |>
		dplyr::nth(1)
	last_value <-
		df |>
		dplyr::arrange(date) |>
		dplyr::slice_tail(n = 2) |>
		dplyr::pull(.data$value) |>
		dplyr::nth(2)
	pct_change <-
		((last_value - next_to_last) / next_to_last) |>
		magrittr::multiply_by(100) |>
		round(1)
	if (pct_change != Inf) {
		pct_change
	} else {
		stop("Divisor was '0'")
	}
}
