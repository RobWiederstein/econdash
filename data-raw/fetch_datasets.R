# code for wei
#set key for FRED
fred_key <- Sys.getenv("FRED_API_KEY")
#fred_key <- {{ secrets.FRED_API_KEY }}
# fetch wei
fredr::fredr_set_key(fred_key)
wei <- fredr::fredr(
	series_id = "WEI",
	observation_start = as.Date("2008-01-05")
)
wei <- wei |> dplyr::select(date, value)
usethis::use_data(wei, overwrite = TRUE)
#fetch recession
file <- "http://data.nber.org/data/us_recessions/20210719_cycle_dates_pasted.csv"
us_recessions <- readr::read_csv(file = file)
usethis::use_data(us_recessions, overwrite = TRUE)
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
##----------------------------------------------------------------
file <- 'https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/SNA_TABLE1/USA+EA19+CHN.B1_GE.VPVOB/all?startTime=2001&endTime=2020'
df <- rsdmx::readSDMX(file = file) |> as.data.frame()
oecd_gdp_total <-
	df |>
	janitor::clean_names() |>
	dplyr::mutate(obs_time = as.Date(paste0(obs_time, "-01-01"), format = "%Y-%m-%d")) |>
	# oecd releases the amt (in millions) US dollars
	dplyr::mutate(obs_value = '/'(obs_value, 1e6) |> round(2))
usethis::use_data(oecd_gdp_total, internal = T, overwrite = T)
##  Consumer prices - Annual inflation, All items non-food non-energy
## https://stats.oecd.org/Index.aspx?QueryId=82173
##................................................................
base <- 'https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/'
variable <- 'PRICES_CPI/'
country <- 'USA+EA19+CHN.'
subject <- 'CPALTT01+CP010000+CPGREN01+CPGRLE01.'
measure <- 'GY.'
frequency <- 'M/'
agency <- 'all'
startTime <- '?startTime=2000-01'
#query
file <- paste0(base, variable, country, subject, measure, frequency, agency, startTime)
df <- rsdmx::readSDMX(file = file) |> as.data.frame()
df.1 <-
	df |>
	janitor::clean_names() |>
	dplyr::mutate(obs_time = as.Date(paste0(obs_time, "-01"), format = "%Y-%m-%d"))
#convert subject codes to names with CPI cross-walk
cpi.cw <- data.frame(subject = c("CP010000", "CPALTT01", "CPGREN01", "CPGRLE01"),
		     names = c("CPI: food & bev. (non-alcoholic)",
		     	  "CPI: all items",
		     	  "CPI: energy",
		     	  "CPI: all items ex-food & energy"
		     )
)
# merge
oecd_prices_cpi <- dplyr::left_join(df.1, cpi.cw, by = "subject")
usethis::use_data(oecd_prices_cpi, internal = T, overwrite = T)
