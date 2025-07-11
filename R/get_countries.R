#' Obtain information on countries that are available in the UNCTAD TRAINS
#' dataset.
#'
#' @description
#' This function obtains all reporters and partners names, alpha numeric codes,
#' ISO3 codes and other meta data about the countries that are available in
#' the UNCTAD TRAINS dataset.
#'
#' No parameters are required.
#'
#' @usage
#' get_countries()
#'
#' @return
#' `get_countries()` returns a data frame with six character columns:
#'
#' * iso3_code: three-letter countries codes;
#' * country_code: three-digit countries codes;
#' * name: countries' names;
#' * is_reporter: the value is 1 if the country is available as reporter
#' and 0 otherwise;
#' * is_partner: the value is 1 if the country is available as partner
#' and 0 otherwise;
#' * is_group: the value is 1 if the code represents a group of countries
#' and 0 otherwise;
#'
#' @export
get_countries <- function() {

  tmp_xml <-  xml2::xml_find_all(
    xml2::read_xml("https://wits.worldbank.org/API/V1/wits/datasource/trn/country/ALL"),
    xpath = "//wits:country"
  )

  tibble::tibble(
    iso3_code = xml2::xml_text(xml2::xml_find_all(tmp_xml, xpath = "//wits:iso3Code")),
    country_code = xml2::xml_attr(tmp_xml, attr = "countrycode"),
    name = xml2::xml_text(xml2::xml_find_all(tmp_xml, xpath = "//wits:name")),
    is_reporter = xml2::xml_attr(tmp_xml, attr = "isreporter"),
    is_partner = xml2::xml_attr(tmp_xml, attr = "ispartner"),
    is_group = ifelse(xml2::xml_attr(tmp_xml, attr = "isgroup") == "Yes", "1", "0"),
    stringsAsFactors = FALSE
  ) %>%
    rbind(
      tibble::tibble(
        iso3_code = "000",
        country_code = "000",
        name = "World",
        is_reporter = "0",
        is_partner = "1",
        is_group = "1",
        stringsAsFactors = FALSE
      )
    ) %>%
    dplyr::arrange(.data$iso3_code)

}
