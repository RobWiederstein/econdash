# code for wei
#set key for FRED
fred_key <- Sys.getenv(FRED_API_KEY)
# fetch wei
fredr::fredr_set_key(fred_key)
wei <- fredr::fredr(
	series_id = "WEI",
	observation_start = as.Date("2008-01-05")
)
wei <- wei |> dplyr::select(date, value)
usethis::use_data(wei, overwrite = TRUE)
#fetch recession
file <- "http://data.nber.org/data/cycles/20210719_cycle_dates_pasted.csv"
cycles <- readr::read_csv(file = file)
usethis::use_data(cycles, overwrite = TRUE)
# fetch sentiment
umcsent <- fredr::fredr(
	series_id = "UMCSENT",
	observation_start = as.Date("2000-01-01")
)
umcsent <- umcsent |> dplyr::select(date, value)
usethis::use_data(umcsent, overwrite = TRUE)
# fetch case-shiller national home price index
csushpinsa <- fredr::fredr(
	series_id = "CSUSHPINSA",
	observation_start = as.Date("2000-01-01")
)
csushpinsa <- csushpinsa |> dplyr::select(date, value)
usethis::use_data(csushpinsa, overwrite = TRUE)

