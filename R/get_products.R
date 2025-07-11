#' Obtain information on products that are available in the UNCTAD TRAINS
#' dataset.
#'
#' @description
#' This function obtains the list of products available in the UNCTAD TRAINS
#' dataset.
#'
#' No parameters are required.
#'
#' @usage
#' get_products()
#'
#' @return
#' `get_products()` returns a data frame with two character columns:
#'
#' * product_code: six-digit product codes (HS6);
#' * product_desc: products' descriptions.
#'
#' @export
get_products <- function() {

  tmp_xml <- xml2::xml_find_all(
    xml2::read_xml("https://wits.worldbank.org/API/V1/wits/datasource/trn/product/all"),
    xpath = "//wits:product"
  )

  tibble::tibble(
    product_code = xml2::xml_attr(tmp_xml, attr = "productcode"),
    product_desc = xml2::xml_text(xml2::xml_find_all(tmp_xml[1], xpath = "//wits:productdescription")),
    stringsAsFactors = FALSE
  )

}
