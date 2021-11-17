test_that("number of df columns", {
	expect_equal(ncol(wei), 2)
})
test_that("is a dataframe", {
	expect_equal(is.data.frame(wei), T)
})
