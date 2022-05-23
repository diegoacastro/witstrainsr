# witstrainsr

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/diegoacastro/witstrainsr/workflows/R-CMD-check/badge.svg)](https://github.com/diegoacastro/witstrainsr/actions)
<!-- badges: end -->

WITS API in R to programmatically access tariff data in UNCTAD TRAINS database.
 
The `witstrainsr` package is an implementation of the World Integrated Trade 
Solution (WITS) API in R to programmatically access tariff data in the UNCTAD 
TRAINS database.

Users can access traded and non-traded tariff lines tariff data, which are 
harmonized across the countries at 6-digit level of the Harmonized System (HS6) 
and are available for preferential and most-favored-nation (MFN) rates.

## Installation

```r
# Install the development version from GitHub:
# install.packages("devtools")
devtools::install_github("diegoacastro/witstrainsr")
```

## Usage

Use the fuction `get_tariffs` to access the tariff data. For example, it is possible to request the import tariffs imposed by European Union in 2015 for all products running the following code:

```r
get_tariffs(
  reporter = "918",
  year = "2015"
)
```

## Getting help

For understanding in details how the API works, see <http://wits.worldbank.org/data/public/WITSAPI_UserGuide.pdf>.
