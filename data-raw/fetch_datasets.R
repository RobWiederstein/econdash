
#                        MISCELLANEOUS                       ----
## us_recessions ----
file <- 'http://data.nber.org/data/cycles/business_cycle_dates.json'
us_recessions <- rjson::fromJSON(file=file)

#                          GENERAL                           ----
## oecd_gdp_total ----
file <- paste0('https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/SNA_TABLE1/',
	       'USA+EA19+CHN.B1_GE.VPVOB/all?startTime=2001&endTime=2020')
df <- rsdmx::readSDMX(file = file) |> as.data.frame()
oecd_gdp_total <-
	df |>
	janitor::clean_names() |>
	dplyr::mutate(obs_time = as.Date(paste0(obs_time, "-01-01"),
					 format = "%Y-%m-%d")) |>
	dplyr::mutate(obs_value = '/'(obs_value, 1e6) |> round(2))
## oecd_gdp_per_capita ----
file <- paste0('https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/SNA_TABLE1/',
	       'USA+EA19+CHN.B1_GE.HVPVOB/all?startTime=2001')
df <- rsdmx::readSDMX(file = file) |> as.data.frame()
oecd_gdp_per_capita <-
	df |>
	janitor::clean_names() |>
	dplyr::mutate(obs_time = as.Date(paste0(obs_time, "-01-01"), format = "%Y-%m-%d")) |>
	dplyr::mutate(obs_value = obs_value |> round(0)) |>
	dplyr::mutate(measure = gsub("HVPVOB", "Per head, constant PPPs", measure))
##  oecd_prices_cpi  ----
file <- paste0('https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/',
	       'PRICES_CPI/USA+EA19+CHN.CPALTT01+CP010000+CPGREN01+CPGRLE01.',
	       'GY.M/all?startTime=2000-01')
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
##  oecd_kei_unempl_rate ----
file <- paste0('https://stats.oecd.org/restsdmx/sdmx.ashx/GetData/',
	       'KEI/LR+LRHUTTTT.USA+EA19+CHN.ST.M/all?',
	       'startTime=2001-11&endTime=2021-10')
df <- rsdmx::readSDMX(file = file) |> as.data.frame()
oecd_kei_unempl_rate <-
	df |>
	janitor::clean_names() |>
	dplyr::mutate(obs_time = as.Date(paste0(obs_time, "-01"), format = '%Y-%m-%d')) |>
	dplyr::mutate(subject = gsub("LRHUTTTT", "Monthly unempl. rate", subject))
#                          HOUSING                           ----
## csushpinsa ----
csushpinsa <- fredr::fredr(series_id = "CSUSHPINSA",
			   observation_start = as.Date("2000-01-01"))
csushpinsa <- csushpinsa |> dplyr::select(date, value)
## redfin ----
file <- paste0('https://redfin-public-data.s3.us-west-2.amazonaws.com/',
	       'redfin_market_tracker/us_national_market_tracker.tsv000.gz')
df <- readr::read_tsv(file = file)

redfin <-
	df |>
	dplyr::filter(is_seasonally_adjusted == TRUE) |>
	dplyr::select(period_begin, property_type, median_sale_price:off_market_in_two_weeks) |>
	tidyr::pivot_longer(cols = median_sale_price:off_market_in_two_weeks) |>
	dplyr::mutate(property_type = tolower(property_type)) |>
	dplyr::mutate(property_type = gsub(" ", "_", property_type)) |>
	dplyr::rename(date = period_begin) |>
	dplyr::filter(!grepl("mom|yoy", name)) |>
	dplyr::mutate(value = round(value, 3)) |>
	dplyr::arrange(date)
## fmac ----
df <- rio::import(file = 'http://www.freddiemac.com/pmms/docs/historicalweeklydata.xls',
		  which ='Full History',
		  range = cellranger::cell_limits(c(8, 1), c(NA, 7)),
		  col_names = c('date',
		  	      'fixed_30_rate',
		  	      'fixed_30_points',
		  	      'fixed_15_rate',
		  	      'fixed_15_points',
		  	      'float_arm_rate',
		  	      'float_arm_points'
		  ),
		  col_types = c('date', rep('text', 6))
)
df.1 <- rio::import(file = 'http://www.freddiemac.com/pmms/docs/historicalweeklydata.xls',
		    which ='1PMMS2022',
		    range = cellranger::cell_limits(c(8, 1), c(NA, 7)),
		    col_names = c('date',
		    	      'fixed_30_rate',
		    	      'fixed_30_points',
		    	      'fixed_15_rate',
		    	      'fixed_15_points',
		    	      'float_arm_rate',
		    	      'float_arm_points'
		    ),
		    col_types = c('date', rep('text', 6))
)
fmac <-
	dplyr::bind_rows(df, df.1) |>
	dplyr::select(c(date, contains("rate"))) |>
	dplyr::mutate(across(-date, as.numeric)) |>
	dplyr::mutate(across(-date, ~ round(., 3))) |>
	tidyr::pivot_longer(-date, names_to = 'mortgage') |>
	dplyr::mutate(date = as.Date(date, format = "%Y-%m-%d")) |>
	na.omit() |>
	dplyr::filter(date > "2000-01-01")
## houst ----
df <- fredr::fredr(series_id = 'houst')
houst <-
	df |>
	dplyr::select(date:value) |>
	dplyr::filter(date > "2000-01-01") |>
	dplyr::mutate(value = value / 1000)

#                          LEADING                           ----
## wei  ----
fred_key <- Sys.getenv("FRED_API_KEY")
fredr::fredr_set_key(fred_key)
wei <- fredr::fredr(series_id = "WEI",
		    observation_start = as.Date("2008-01-05"))
wei <- wei |> dplyr::select(date, value)
## ads business conditions index ----
df <- rio::import(
	file = paste0(
		"https://www.philadelphiafed.org/-/media/frbp/assets/surveys-and-data/",
		"ads/ads_index_most_current_vintage.xlsx?la=en&hash=6DF4E54DFAE3EDC347F80A80142338E7"
	),
	col_names = c("date", "ads_idx"),
	col_types = c("text", "numeric")
)
adsidx <-
	df |>
	dplyr::mutate(date = as.Date(date, format = "%Y:%m:%d")) |>
	dplyr::filter(date > "2000-01-01") |>
	na.omit()
#                          SENTIMENT                         ----
## umcsent ----
umcsent <- fredr::fredr(series_id = "UMCSENT",
			observation_start = as.Date("2000-01-01"))
umcsent <- umcsent |> dplyr::select(date, value)
## vix ----
library(tidyquant)
tickers <- c("^VIX", "SPY")
df <- tidyquant::tq_get(tickers, get = 'stock.prices')
vix <- df |>
	dplyr::select(date, symbol, close) |>
	dplyr::filter(symbol == "^VIX")
#                            STOCKS                           ----
## wb_wdi_mkt_cap ----
df <- rdbnomics::rdb("WB", "WDI", dimensions = list(
	country = c("US", "CN", "IN", "EU", "JP"),
	indicator = "CM.MKT.LCAP.GD.ZS")
)
wb_wdi_mkt_cap <-
	df |>
	dplyr::mutate(original_period = as.integer(original_period)) |>
	dplyr::filter(original_period > 2000) |>
	dplyr::mutate(value = round(value, 1))

#                      SAVE INTERNAL DATA                     ----
usethis::use_data(# misc
	us_recessions,
	# general
	  oecd_gdp_total,
	  oecd_gdp_per_capita,
	  oecd_prices_cpi,
	  oecd_kei_unempl_rate,
	# housing
	  csushpinsa,
	  redfin,
	  fmac,
	  houst,
	# leading
	  wei,
	  adsidx,
	# sentiment
	  umcsent,
	  vix,
	# stocks
	  wb_wdi_mkt_cap,
	  internal = T,
	  overwrite = TRUE)
#                            END                             ----

