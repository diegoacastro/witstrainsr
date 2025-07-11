#' Obtain availability in the UNCTAD TRAINS dataset.
#'
#' @description
#' This function obtains the data availability of entire TRAINS dataset.
#'
#' No parameters are required.
#'
#' @usage
#' get_availability()
#'
#' @return
#' `get_availability()` returns a data frame with nine character columns:
#'
#' * iso3_code: reporters three-letter countries codes;
#' * country_code: reporters three-digit countries codes;
#' * country_name: reporters names;
#' * year;
#' * nomen_code: reported nomenclature;
#' * n_preferential_agreement: number of preferential agreement available;
#' * partner_list: set of partners three-digit countries codes;
#' * specific_duty: the value is 1 if the estimated tariff rate is
#' available for specific duty expression and 0 otherwise;
#' * last_update: last updated date.
#'
#' @export
get_availability <- function() {

  tmp_xml <- xml2::xml_find_all(
    xml2::read_xml("https://wits.worldbank.org/API/V1/wits/datasource/trn/dataavailability/"),
    xpath = "//wits:reporter"
  )

  tibble::tibble(
    iso3_code = xml2::xml_attr(tmp_xml, attr = "iso3Code"),
    country_code = xml2::xml_attr(tmp_xml, attr = "countrycode"),
    country_name = xml2::xml_text(xml2::xml_find_all(tmp_xml[1], xpath = "//wits:name")),
    year = xml2::xml_text(xml2::xml_find_all(tmp_xml[1], xpath = "//wits:year")),
    nomen_code = xml2::xml_text(xml2::xml_find_all(tmp_xml[1], xpath = "//wits:reporternernomenclature")),
    n_preferential_agreement = as.integer(xml2::xml_text(xml2::xml_find_all(tmp_xml[100], xpath = "//wits:numberofpreferentialagreement"))),
    partner_list = xml2::xml_text(xml2::xml_find_all(tmp_xml[1], xpath = "//wits:partnerlist")),
    specific_duty = xml2::xml_text(xml2::xml_find_all(tmp_xml[1], xpath = "//wits:isspecificdutyexpressionestimatedavailable")),
    last_update = xml2::xml_text(xml2::xml_find_all(tmp_xml[1], xpath = "//wits:lastupdateddate")),
    stringsAsFactors = FALSE
  )

}
