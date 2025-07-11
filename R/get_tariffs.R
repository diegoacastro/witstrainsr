#' Access UNCTAD TRAINS tariff data.
#'
#' @description
#' This function allows the user to access the traded and non-traded tariff
#' lines tariff data from the UNCTAD TRAINS dataset. Data are harmonized across
#' the countries at 6-digit level of the Harmonized System (HS6) and are
#' available for preferential and most-favored-nation (MFN) rates.
#'
#' @usage
#' get_tariffs(reporter, partner, product, year, datatype)
#'
#' @param reporter A character vector with reporters three-digit ISO Country
#' Codes or `"all"`.
#' @param partner A character vector with partners three-digit ISO Country
#' Codes, `"all"` or `"000"` (world, the default).
#' @param product A character vector with six-digit product codes (HS6) or
#' `"all"` (the default).
#' @param year A character, numeric or integer vector with years in the
#' four-digit format.
#' @param datatype Should be "reported" (the default) or "aveestimated".
#' "reported" provides only tariff rates and "aveestimated" provides tariff
#' rates and ad valorem equivalents of specific duties estimated using UNCTAD
#' methods.
#'
#' @return
#' `get_tariffs()` returns a data frame with the following columns:
#'
#' * reporter_country_code: reporter three-digit ISO Country Code;
#' * partner_country_code: partner three-digit ISO Country Code;
#' * product_code: 6-digit HS code;
#' * year: year in which the tariff was valid;
#' * tariff_simple_average: simple average of ad valorem tariff rates from all
#' national tariff lines within the corresponding HS 6-digit code;
#' * tariff_type: identifies whether the tariff rate is Preferential (PREF) or
#' most-favored-nation (MFN);
#' * n_total_lines: total number of national tariff lines within the
#' corresponding HS 6-digit code;
#' * n_pref_lines: number of national tariff lines within the corresponding HS
#' 6-digit code for which preferential rates are applicable;
#' * n_mfn_lines: number of national tariff lines within the corresponding HS
#' 6-digit code for which preferential rates are NOT applicable (so that MFN
#' rates are used in the calculation of the simple average);
#' * n_specific_duty_lines: number of national tariff lines within the
#' corresponding HS 6-digit code for which preferential rates are NOT in ad
#' valorem form (so that the line is not included in the calculation of the
#' simple average);
#' * tariff_sum_rates: sum of ad valorem tariff rates from all national tariff
#' lines within the corresponding HS 6-digit code;
#' * tariff_min_rate: lowest ad valorem tariff rates among all national tariff
#' lines within the corresponding HS 6-digit code;
#' * tariff_max_rate: highest ad valorem tariff rates among all national tariff
#' lines within the corresponding HS 6-digit code;
#' * nomen_code: revision of HS used (H0 = HS 1988/92, H1= HS 1996,
#' H2 = HS 2002, H3 = HS 2007, H4 = HS 2012).
#'
#' @details
#' The WITS API retrieves MFN tariff lines only for the partner `world`.
#'
#' Besides, to avoid server overload, it is not possible to request the entire
#' database in one query. The options to request data are the following:
#'
#' * All products tariff schedules can be requested for a single reporter,
#' partner and year;
#' * Tariff schedule for a single reporter, partner, and product can be
#' requested for a range of years;
#' * Tariff schedule for one or more reporters, one or more partners, one or
#' more products can be requested for a single year;
#' * Either reported or AVE estimated data type can be requested in a single
#' request.
#'
#' @seealso
#' <http://wits.worldbank.org/data/public/WITSAPI_UserGuide.pdf> for the
#' official WITS-API USER GUIDE. This guide is especially useful for
#' understanding the use of the parameters and request errors.
#'
#' @examples
#' ## Not run:
#'
#' # Request two reporters (Brazil and United States) - all partners - one
#' # product ("870350") - one year (2017) - reported tariff rate:
#'
#' get_tariffs(
#'   reporter = c("076", "840"),
#'   partner = "all",
#'   product = "870350",
#'   year = "2017"
#' )
#'
#' ## Note that, if the reporter vector above is replaced by "all", it will
#' ## throw the following error: "The provided parameter values return large data".
#'
#' # Request all reporters - one partner (Japan) - one product ("851830")
#' # - one year (2017) - reported and AVE estimated tariff rates:
#'
#' get_tariffs(
#'   reporter = "all",
#'   partner = "392",
#'   product = "851830",
#'   year = "2017",
#'   datatype = "aveestimated"
#' )
#'
#' ## Note that the request above returns only preferencial rates, since MFN
#' ## tariff rates are only provided for the partner world.
#'
#' # Request one reporter (European Union) - one partner (world) - all products
#' # - one year (2015) - reported tariff rates:
#'
#' get_tariffs(
#'   reporter = "918",
#'   year = "2015"
#' )
#'
#' ## End(Not run)
#'
#' @export
get_tariffs <- function(reporter,
                        partner = "000",
                        product = "all",
                        year,
                        datatype = "reported") {

  # Initial paramenters check
  if(!(is.character(reporter) & sum(nchar(reporter) == 3) == length(reporter))) {
    stop("The reporter parameter should be the value of \"all\" or a character vector with 3-digits country codes.")
  }

  if(!(is.character(partner) & sum(nchar(partner) == 3) == length(partner))) {
    stop("The partner parameter should be the value of \"all\" or a character vector with 3-digits country codes.")
  }

  if(!(is.character(product) & (sum(nchar(product) == 6) == length(product) | product == "all"))) {
    stop("The product parameter should be the value of \"all\" or a character vector with HS6 codes.")
  }

  if(!(sum(nchar(year) == 4) == length(year) | year == "all")) {
    stop("The year parameter should be the value of \"all\" or a vector with years in the 4 digit year format.")
  }

  if(!(datatype %in% c("reported", "aveestimated"))) {
    stop("The datatype parameter should be \"reported\" or \"aveestimated\".")
  }

  # Url used to extract the data
  url_request <- paste0(
    "https://wits.worldbank.org/API/V1/SDMX/V21/datasource/TRN",
    "/reporter/", paste0(reporter, collapse = ";"),
    "/partner/", paste0(partner, collapse = ";"),
    "/product/", paste0(product, collapse = ";"),
    "/year/", paste0(year, collapse = ";"),
    "/datatype/", datatype
  )

  # Verify errors in the request
  check_error <-  httr::content(
    httr::GET(url_request),
    "text",
    encoding = "UTF-8"
  )

  if(stringr::str_detect(check_error, "wits:error")) {
    stop(stringr::str_extract(check_error, "((?<=(\\.\"&gt;)).+)(.+(?=(&lt;\\/wits:message)))"))
  }

  if(stringr::str_detect(check_error, "NoRecordsFound")) {
    stop("No records found. Please, verify the parameters used in the request.")
  }

  # Extract data
  xml_request <- xml2::read_xml(url_request)

  xml_data <- xml_request %>%
    xml2::xml_find_all(.data, xpath = "//Obs")

  xml_parameters <- xml_request %>%
    xml2::xml_find_all(.data, xpath = "//Series")

  tibble::tibble(
    reporter_country_code = xml2::xml_attr(xml_parameters, attr = "REPORTER"),
    partner_country_code = xml2::xml_attr(xml_parameters, attr = "PARTNER"),
    product_code = xml2::xml_attr(xml_parameters, attr = "PRODUCTCODE"),
    year = xml2::xml_attr(xml_data, attr = "TIME_PERIOD"),
    tariff_simple_average = as.numeric(xml2::xml_attr(xml_data, attr = "OBS_VALUE")),
    tariff_type = xml2::xml_attr(xml_data, attr = "TARIFFTYPE"),
    n_total_lines = as.integer(xml2::xml_attr(xml_data, attr = "TOTALNOOFLINES")),
    n_pref_lines = as.integer(xml2::xml_attr(xml_data, attr = "NBR_PREF_LINES")),
    n_mfn_lines = as.integer(xml2::xml_attr(xml_data, attr = "NBR_MFN_LINES")),
    n_specific_duty_lines = as.integer(xml2::xml_attr(xml_data, attr = "NBR_NA_LINES")),
    tariff_sum_rates = as.numeric(xml2::xml_attr(xml_data, attr = "SUM_OF_RATES")),
    tariff_min_rate = as.numeric(xml2::xml_attr(xml_data, attr = "MIN_RATE")),
    tariff_max_rate = as.numeric(xml2::xml_attr(xml_data, attr = "MAX_RATE")),
    nomen_code = xml2::xml_attr(xml_data, attr = "NOMENCODE")
  )

}
