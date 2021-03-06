% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/btps.R
\name{get_btps_factor}
\alias{get_btps_factor}
\title{Get BTPS Correction factor}
\usage{
get_btps_factor(temp)
}
\arguments{
\item{temp}{(Numeric) Room Temperature when gas was collected.}
}
\value{
A numeric factor to convert volume of gas to 37 celsius saturated
}
\description{
Compute correction factor to convert gas volumes from room temperature saturated to BTPS, assuming that gas was sampled at barometric pressure of 760 mmHg.
}
\examples{
# If temp in lookup table, simply use BTPS Correction factor from the table
get_btps_factor(20)
# If temp not in lookup table, use prediction by linear model.
get_btps_factor(20.5)
}
