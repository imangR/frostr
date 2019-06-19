#' @title Get metadata on available time series in the "observation" resource
#'
#' @description \code{get_available_timeseries()} retrieves metadata on available
#' time series that you can get from the Frost API "observations" resource
#' with \code{\link{get_observations}()}. The function requires input for
#' \code{client_id} and \code{sources}. The other function arguments are optional,
#' and default to \code{NULL}, which means that the response from the API is not
#' filtered on these parameters.
#'
#' @usage
#' get_available_timeseries(client_id,
#'                          sources,
#'                          reference_time = NULL,
#'                          elements = NULL,
#'                          time_offsets = NULL,
#'                          time_resolutions = NULL,
#'                          time_series_ids = NULL,
#'                          performance_categories = NULL,
#'                          exposure_categories = NULL,
#'                          levels = NULL,
#'                          level_types = NULL,
#'                          level_units = NULL,
#'                          fields = NULL,
#'                          return_response = FALSE)
#'
#' @param client_id A string. The client ID to use to send requests to the
#' Frost API.
#'
#' @param sources A character vector. The station IDs of the data sources
#' to get observations for. For example, "SN18700" is the station ID for
#' "Blindern". The full list of station IDs can be retrieved with
#' \code{get_sources()}.
#'
#' @param reference_time A string. The time range to get observations for in
#' either extended ISO-8601 format or the single word "latest".
#'
#' @param elements A character vector. The elements to get observations for.
#' The full list of elements can be retrieved with the
#' \code{get_elements()}.
#'
#' @param time_offsets A character vector. The time offsets to get observations
#' for provided as a vector of ISO-8601 periods, e.g. \code{c("PT6H", "PT18H")}.
#'
#' @param time_resolutions A character vector. The time resolutions to get
#' observations for provided as a vector of ISO-8601 periods e.g.
#' \code{c("PT6H", "PT18H")}.
#'
#' @param time_series_ids A numeric vector. The internal time series IDs to get
#' observations for as a vector of integers, e.g. c(0, 1).
#'
#' @param performance_categories A character vector. The performance categories
#' to get observations for as a vector of letters, e.g. \code{c("A", "C")}.
#'
#' @param exposure_categories A numeric vector. The exposure categories to get
#' observations for as a vector of integers, e.g. \code{c(1, 2)}.
#'
#' @param levels A numeric vector. The sensor levels to get observations for as
#' a vector of integers, e.g. \code{c(1, 2, 10, 20)}.
#'
#' @param level_types A character vector. The sensor level types to get data
#' for.
#'
#' @param level_units A character vector. The sensor level units to get data
#' for.
#'
#' @param fields A character vector. Fields to include in the response (i.e.
#' output). If this parameter is specified, then only these fields are
#' returned in the response. If not specified, then all fields will be
#' returned in the response.
#'
#' @param return_response A logical. If set to \code{TRUE}, then the function
#' returns the response from the GET request. If set to \code{FALSE} (default),
#' then the function returns a tibble (data frame) of the content in the
#' response.
#'
#' @return The function returns either a data frame with metadata about
#' available time series, or the response of the GET request, depending
#' on the boolean value set for \code{return_response}.
#'
#' @examples
#' \donttest{
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get metadata on available time series for Blindern station (with station
#' # ID SN18700)
#' sources <- "SN18700"
#'
#' obs.timeseries <- get_available_timeseries(client_id = client.id,
#'                                            sources = sources)
#' }
#'
#' @export get_available_timeseries

get_available_timeseries <-
  function(
    client_id,
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
    return_response = FALSE
  ) {

    input_args <-
      list(
        sources               = frost_csl(sources),
        referencetime         = reference_time,
        elements              = frost_csl(elements),
        timeoffsets           = frost_csl(time_offsets),
        timeresolutions       = frost_csl(time_resolutions),
        timeseriesids         = frost_csl(time_series_ids),
        performancecategories = frost_csl(performance_categories),
        exposurecategories    = frost_csl(exposure_categories),
        levels                = frost_csl(levels),
        levelTypes            = frost_csl(level_types),
        levelUnits            = frost_csl(level_units),
        fields                = frost_csl(fields)
      )

    frost_control_args(input_args = input_args, func = "get_available_timeseries")

    url <-
      paste0("https://", client_id,
             "@frost.met.no/observations/availableTimeSeries/v0.jsonld",
             collapse = NULL)

    frostr_ua <- httr::user_agent("https://github.com/PersianCatsLikeToMeow/frostr")

    r <- httr::GET(url, query = input_args, frostr_ua)

    httr::stop_for_status(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
