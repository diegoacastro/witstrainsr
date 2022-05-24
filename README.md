
<!-- README.md is generated from README.Rmd. Please edit that file -->

# witstrainsr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/diegoacastro/witstrainsr/workflows/R-CMD-check/badge.svg)](https://github.com/diegoacastro/witstrainsr/actions)
<!-- badges: end -->

## Overview

WITS API in R to programmatically access tariff data in UNCTAD TRAINS
database.

The `witstrainsr` package is an implementation of the World Integrated
Trade Solution (WITS) API in R to programmatically access tariff data in
the UNCTAD TRAINS database.

Users can access traded and non-traded tariff lines tariff data, which
are harmonized across the countries at 6-digit level of the Harmonized
System (HS6) and are available for preferential and most-favored-nation
(MFN) rates.

## Installation

``` r
# Install the development version from GitHub:
# install.packages("devtools")
devtools::install_github("diegoacastro/witstrainsr")
```

## Usage

The main function of this package is `get_tariffs`, which requests
tariff data using the API. There are, also, functions that provide
information about the arguments of `get_tariffs`, such as
`get_countries` (function that presents all reporters and partners
names, alpha numeric codes, ISO3 codes and other meta data about the
countries that are available in the dataset).

Suppose that the user wants to request the import tariffs imposed by
Brazil in 2015 for all products. The first step is to find out what is
the country code for Brazil. It can be done by using `get_countries`:

``` r
library(witstrainsr)

get_countries() %>% 
  subset(., name == "Brazil", select = country_code)
#>    country_code
#> 80          076
```

Now, using `get_tariffs` and the country code, it is possible to collect
the Brazilian import tariffs in 2015 running the following code:

``` r
tariffs <- get_tariffs(
  reporter = "076",
  year = "2015"
)

str(tariffs)
#> 'data.frame':    5205 obs. of  14 variables:
#>  $ reporter_country_code: chr  "076" "076" "076" "076" ...
#>  $ partner_country_code : chr  "000" "000" "000" "000" ...
#>  $ product_code         : chr  "010121" "010129" "010130" "010190" ...
#>  $ year                 : chr  "2015" "2015" "2015" "2015" ...
#>  $ tariff_simple_average: num  0 2 4 4 0 2 0 2 0 0 ...
#>  $ tariff_type          : chr  "MFN" "MFN" "MFN" "MFN" ...
#>  $ n_total_lines        : int  1 1 1 1 2 3 2 3 1 1 ...
#>  $ n_pref_lines         : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ n_mfn_lines          : int  1 1 1 1 2 3 2 3 1 1 ...
#>  $ n_specific_duty_lines: int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ tariff_sum_rates     : num  0 2 4 4 0 6 0 6 0 0 ...
#>  $ tariff_min_rate      : num  0 2 4 4 0 2 0 2 0 0 ...
#>  $ tariff_max_rate      : num  0 2 4 4 0 2 0 2 0 0 ...
#>  $ nomen_code           : chr  "H4" "H4" "H4" "H4" ...
```

## Getting help

For understanding in details how the API works, see
<http://wits.worldbank.org/data/public/WITSAPI_UserGuide.pdf>.
