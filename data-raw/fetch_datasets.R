
#                        MISCELLANEOUS                       ----
## us_recessions ----
file <- 'http://data.nber.org/data/cycles/business_cycle_dates.json'
us_recessions <- rjson::fromJSON(file=file)
df <- do.call(rbind.data.frame, us_recessions)
colnames(df) <- c('from', 'to')
us_recessions <-
	df |>
	dplyr::transmute(from = highcharter::datetime_to_timestamp(as.Date(from)),
		  to = highcharter::datetime_to_timestamp(as.Date(to))) |>
	purrr::transpose()


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
#                        HOUSEHOLDS                          ----
## nyfed_qhdc_tot_debt ----
### import ----
file <- 'https://www.newyorkfed.org/medialibrary/interactives/householdcredit/data/xls/hhd_c_report_2021q4.xlsx'
file_import <-
	rio::import(file = file,
		    sheet = 'Page 3 Data',
		    range = cellranger::cell_limits(c(4, 1), c(NA,NA)),
		    col_names = c(
		    	'quarter',
		    	'mortgage',
		    	'heloc',
		    	'auto_loan',
		    	'credit_card',
		    	'student_loan',
		    	'other',
		    	'total'
		    ),
		    col_types = c("text", rep("numeric", 7))
	)
### build df----
qhdc <-
	file_import |>
	dplyr::mutate(quarter = zoo::as.yearqtr(file_import$quarter, format = "%y:Q%q")) |>
	dplyr::mutate(quarter = zoo::as.Date(quarter)) |>
	dplyr::mutate(across(mortgage:total, ~round(.x, 4))) |>
	tidyr::pivot_longer(-quarter, names_to = "loan_type") |>
	dplyr::filter(loan_type != "total") |>
	tidyr::drop_na()
### adjust for inflation ----
qhdc.1 <-
	qhdc |>
	dplyr::mutate(infl_adj_2020 =
	       	priceR::afi(
	       		price = qhdc$value,
	       		from_date = qhdc$quarter,
	       		country = "US",
	       		to_date = "2020-01-01"
	       	)) |>
	dplyr::mutate(infl_adj_2020 = round(infl_adj_2020, 2))
### pivot wider ----
nyfed_qhdc_tot_debt <-
	qhdc.1 |>
	dplyr::select(-value) |>
	tidyr::pivot_wider(
		id_cols = quarter,
		names_from = loan_type,
		values_from = infl_adj_2020
	)
## nyfed_qhdc_30_del ----
### import ----
file <- 'https://www.newyorkfed.org/medialibrary/interactives/householdcredit/data/xls/hhd_c_report_2021q4.xlsx'
file_import <-
	rio::import(file = file,
		    sheet = 'Page 13 Data',
		    range = cellranger::cell_limits(c(5, 1), c(NA, 8)),
		    col_names = c(
		    	'quarter',
		    	'mortgage',
		    	'heloc',
		    	'auto_loan',
		    	'credit_card',
		    	'student_loan',
		    	'other',
		    	'total'
		    ),
		    col_types = c("text", rep("numeric", 7))
	)
### create df ----
nyfed_qhdc_30_del <-
	file_import |>
	dplyr::mutate(quarter = zoo::as.Date(zoo::as.yearqtr(quarter, format = "%y:Q%q"))) |>
	dplyr::mutate(across(mortgage:total, ~round(.x, 1))) |>
	tidyr::pivot_longer(mortgage:total,
			    names_to = "loan_type",
			    values_to = "percent") |>
	tidyr::drop_na()
## nyfed_qhdc_mo_cs ----
file <- 'https://www.newyorkfed.org/medialibrary/interactives/householdcredit/data/xls/hhd_c_report_2021q4.xlsx'
file_import <-
	rio::import(file = file,
		    sheet = 'Page 6 Data',
		    range = cellranger::cell_limits(c(5, 1), c(NA, 6)),
		    col_names = c(
		    	'quarter',
		    	'<620',
		    	'620-659',
		    	'660-719',
		    	'720-759',
		    	'760+'
		    ),
		    col_types = c("text", rep("numeric", 5))
	)
nyfed_qhdc_mo_cs <-
	file_import |>
	dplyr::mutate(quarter = zoo::as.Date(zoo::as.yearqtr(quarter, format = "%y:Q%q"))) |>
	tidyr::drop_na()
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
## nyfed yield spread ----
file <- "https://www.newyorkfed.org/medialibrary/media/research/capital_markets/allmonth.xls"
df <- rio::import(file = file,
		  setclass = "tibble",
		  which = "rec_prob",
		  skip = 1,
		  col_names = c('date',
		  	      'yield_10_yr',
		  	      'yield_03_mo',
		  	      'yield_03_mo_bond_equiv',
		  	      'spread',
		  	      'rec_prob',
		  	      'nber_rec'),
		  col_types = c('date',
		  	      rep('numeric', 6))
)

yield_spread <-
	df |>
	dplyr::mutate(date = as.Date(date, format = "%Y-%m-%d")) |>
	dplyr::filter(date > "2000-01-01") |>
	na.omit() |>
	dplyr::mutate(rec_prob = round(rec_prob * 100, 1)) |>
	dplyr::select(date, rec_prob, spread) |>
	tidyr::pivot_longer(-date, names_to = "variable",
			    values_to = "value") |>
	na.omit()
## Piger Smoothed Recession Probabilities ----
df <- fredr::fredr(series_id = 'RECPROUSM156N')
piger_rec_prob <-
	df |>
	dplyr::select(date:value) |>
	dplyr::filter(date > "2000-01-01") |>
	na.omit()
#                          SENTIMENT                         ----
## umcsent ----
umcsent <- fredr::fredr(series_id = "UMCSENT",
			observation_start = as.Date("2000-01-01"))
umcsent <- umcsent |> dplyr::select(date, value)
## ymics ----
file <- paste0(
	"https://shiller-data-public.s3.amazonaws.com/",
	"icf_stock_market_confidence_index_table.csv"
)
df <- readr::read_csv(
	file = file,
	skip = 2,
	col_names = c(
		"date",
		"institutional",
		"inst_se",
		"individual",
		"ind_se"
	),
	col_select = c(1, 2, 4),
	col_types = readr::cols_only(
		date = readr::col_date(format = "%m/%Y"),
		institutional = readr::col_number(),
		individual = readr::col_number()
	)
)
yale_inv_conf_survey <-
	df |>
	dplyr::filter(date > "2000-01-01") |>
	tidyr::pivot_longer(-date, names_to = "variable")
## aaai investor sentiment spread ----
file <- 'https://www.aaii.com/files/surveys/sentiment.xls'
temp_file <- tempfile()
download.file(url = file, destfile = temp_file, mode = "wb")
df <- readxl::read_xls(path = temp_file,
		       sheet = 'SENTIMENT',
		       skip = 3,
		       .name_repair = tolower)
##
df$month <- lubridate::floor_date(df$date, "month")
aaii_inv_sent <-
	df |>
	dplyr::mutate(bull_bear_spread = bullish - bearish) |>
	dplyr::select(date, month, bull_bear_spread) |>
	dplyr::group_by(month) |>
	dplyr::summarize(bull_bear_spread = mean(bull_bear_spread,na.rm = T)) |>
	dplyr::mutate(month  = as.Date(month)) |>
	tidyr::pivot_longer(-month,
			    names_to = 'variable',
			    values_to = 'percent') |>
	dplyr::mutate(percent = percent * 100) |>
	dplyr::filter(month > "2000-01-01") |>
	na.omit()
## vix ----
tickers <- c("^VIX", "SPY")
df <- tidyquant::tq_get(tickers, get = 'stock.prices')
vix <- df |>
	dplyr::select(date, symbol, close) |>
	dplyr::filter(symbol == "^VIX")
#                            STOCKS                           ----
## wb_wdi_mkt_cap ----
df <-
	rdbnomics::rdb("WB", "WDI", dimensions = list(
	country = c("USA", "CHN", "IND", "EUU", "JPN"),
	indicator = "CM.MKT.LCAP.GD.ZS")
)
wb_wdi_mkt_cap <-
	df |>
	dplyr::mutate(original_period = as.integer(original_period)) |>
	dplyr::filter(original_period > 2000) |>
	dplyr::mutate(value = round(value, 1))

## shiller pe ratio ----
file <- paste0('https://data.nasdaq.com/api/v3/datasets/MULTPL/SHILLER_PE_RATIO_YEAR.csv?api_key=',
	       Sys.getenv('QUANDL_API_KEY')
)
df <- readr::read_csv(file = file,
		      name_repair = tolower)
shiller <- xts::xts(df$value, order.by = df$date)
## finra margin amount ----
file <- 'https://www.finra.org/sites/default/files/2021-03/margin-statistics.xlsx'
df <- rio::import(file = file,
		  skip = 1,
		  .name_repair = janitor::make_clean_names,
		  col_names = c("date", "debit_margin",
		  	      'credit_cash', 'credit_margin'))
finra_margin_debt <-
	df |>
	dplyr::mutate(date = as.Date(paste0(date, '-01'))) |>
	dplyr::mutate(net_margin = debit_margin - (credit_cash + credit_margin)) |>
	dplyr::mutate(net_margin = net_margin / 1000) |>
	dplyr::select(date, net_margin)  |>
	na.omit()

#                      SAVE INTERNAL DATA                     ----
usethis::use_data(# misc
	us_recessions,
	# general
	  oecd_gdp_total,
	  oecd_gdp_per_capita,
	  oecd_prices_cpi,
	  oecd_kei_unempl_rate,
	# households
	  nyfed_qhdc_tot_debt,
	  nyfed_qhdc_30_del,
	  nyfed_qhdc_mo_cs,
	# housing
	  csushpinsa,
	  redfin,
	  fmac,
	  houst,
	# leading
	  wei,
	  adsidx,
	  yield_spread,
	  piger_rec_prob,
	# sentiment
	  umcsent,
	  yale_inv_conf_survey,
	  aaii_inv_sent,
	  vix,
	# stocks
	  wb_wdi_mkt_cap,
	  shiller,
	  finra_margin_debt,
	  internal = T,
	  overwrite = TRUE)


#                            END                             ----

