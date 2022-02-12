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
#' # positive result
#' pos_data_set <- data.frame(date = as.Date(c("2020-01-01",
#' "2020-02-01", "2020-03-01" )), value = c(1, 1.1, 1.2))
#' # negative result
#' neg_data_set <- data.frame(date = as.Date(c(
#' "2020-01-01", "2020-02-01", "2020-03-01")), value = c(1, 1.1, 1.0))
#'
#' chg2pct(pos_data_set)
#' chg2pct(neg_data_set)
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
#' Return an arrow icon for valueBox
#'
#' Takes a value and returns an up arrow if positive, a down arrow if
#' negative, and a horizontal arrows for zero.
#'
#' @param number a number
#'
#' @return arrow icon for valueBox
#'
#' @details
#'
#' For the arguments for valueBox, query `?shinydashboard::valueBox`.
#'
#'
#' @examples
#' \dontrun{
#' arrow_direction(number = 0)
#' arrow_direction(number = 1)
#' arrow_direction(number = -1)
#' arrow_direction(number = NA)
#'}
#'
insert_arrow <- function(number = 0){
	assertive::assert_is_numeric(number)
	icon = if(number > 0){
		icon('arrow-up')
	}else if(number < 0){
		icon('arrow-down')
	}else{
		icon('arrows-alt-h')
	}
	icon
}
#' Return a color for valueBox
#'
#' Takes a value and returns the color 'green' if positive, the
#' color 'red', if negative, and the color 'blue' for anything else.
#'
#' @param number a number
#'
#' @return a color for valueBox
#'
#' @details
#'
#' For the arguments for valueBox, query `?shinydashboard::valueBox`.
#'
#' @examples
#' \dontrun{
#' color_box(number = 0)
#' color_box(number = 1)
#' color_box(number = -1)
#' color_box(number = NA)
#'}
color_box <- function(number = 0){
	assertive::assert_is_numeric(number)
color =
	if(number > 0){
		"green"
	}else if(number < 0){
		"red"
	}else{
		"blue"
	}
color
}
