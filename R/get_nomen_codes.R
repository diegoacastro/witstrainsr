#' Obtain information on nomenclatures that are available in the UNCTAD TRAINS
#' dataset.
#'
#' @description
#' This function extracts information on nomenclatures that are available in the
#' UNCTAD TRAINS dataset.
#'
#' No parameters are required.
#'
#' @usage
#' get_nomen_codes()
#'
#' @return
#' `get_nomen_codes()` returns a data frame with two character columns:
#'
#' * nomen_code: nomenclature code;
#' * description: nomenclature description.
#'
#' @export
get_nomen_codes <- function() {

  tmp_xml <-  xml2::xml_find_all(
    xml2::read_xml("https://wits.worldbank.org/API/V1/wits/datasource/trn/nomenclature/"),
    xpath = "//wits:nomenclature"
  )

  tibble::tibble(
    nomen_code = xml2::xml_attr(tmp_xml, "nomenclaturecode"),
    description = xml2::xml_text(tmp_xml),
    stringsAsFactors = FALSE
  )

}
