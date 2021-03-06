% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_available_timeseries.R
\name{get_available_timeseries}
\alias{get_available_timeseries}
\title{Get metadata on available time series in the "observation" resource}
\usage{
get_available_timeseries(client_id,
                         sources,
                         reference_time = NULL,
                         elements = NULL,
                         time_offsets = NULL,
                         time_resolutions = NULL,
                         time_series_ids = NULL,
                         performance_categories = NULL,
                         exposure_categories = NULL,
                         levels = NULL,
                         level_types = NULL,
                         level_units = NULL,
                         fields = NULL,
                         return_response = FALSE)
}
\arguments{
\item{client_id}{A string. The client ID to use to send requests to the
Frost API.}

\item{sources}{A character vector. The station IDs of the data sources
to get observations for. For example, "SN18700" is the station ID for
"Blindern". The full list of station IDs can be retrieved with
\code{get_sources()}.}

\item{reference_time}{A string. The time range to get observations for in
either extended ISO-8601 format or the single word "latest".}

\item{elements}{A character vector. The elements to get observations for.
The full list of elements can be retrieved with the
\code{get_elements()}.}

\item{time_offsets}{A character vector. The time offsets to get observations
for provided as a vector of ISO-8601 periods, e.g. \code{c("PT6H", "PT18H")}.}

\item{time_resolutions}{A character vector. The time resolutions to get
observations for provided as a vector of ISO-8601 periods e.g.
\code{c("PT6H", "PT18H")}.}

\item{time_series_ids}{A numeric vector. The internal time series IDs to get
observations for as a vector of integers, e.g. c(0, 1).}

\item{performance_categories}{A character vector. The performance categories
to get observations for as a vector of letters, e.g. \code{c("A", "C")}.}

\item{exposure_categories}{A numeric vector. The exposure categories to get
observations for as a vector of integers, e.g. \code{c(1, 2)}.}

\item{levels}{A numeric vector. The sensor levels to get observations for as
a vector of integers, e.g. \code{c(1, 2, 10, 20)}.}

\item{level_types}{A character vector. The sensor level types to get data
for.}

\item{level_units}{A character vector. The sensor level units to get data
for.}

\item{fields}{A character vector. Fields to include in the response (i.e.
output). If this parameter is specified, then only these fields are
returned in the response. If not specified, then all fields will be
returned in the response.}

\item{return_response}{A logical. If set to \code{TRUE}, then the function
returns the response from the GET request. If set to \code{FALSE} (default),
then the function returns a tibble (data frame) of the content in the
response.}
}
\value{
The function returns either a data frame with metadata about
available time series, or the response of the GET request, depending
on the boolean value set for \code{return_response}.
}
\description{
\code{get_available_timeseries()} retrieves metadata on available
time series that you can get from the Frost API "observations" resource
with \code{\link{get_observations}()}. The function requires input for
\code{client_id} and \code{sources}. The other function arguments are optional,
and default to \code{NULL}, which means that the response from the API is not
filtered on these parameters.
}
\examples{
\dontrun{
frost_client_id <- "<YOUR FROST CLIENT ID>"

# Get metadata on available time series for Blindern station (with station
# ID SN18700)
sources <- "SN18700"

obs_available_ts <- get_available_timeseries(client_id = frost_client_id,
                                             sources   = sources)
}

}
