#' @title Get weather observations from the "observation" resource in the Frost API
#'
#' @description \code{get_observations()} retrieves historical weather data
#' from the Frost API. This is the core resource for retrieving actual
#' observation data from MET Norway's data storage systems. The function
#' requires input for \code{client_id}, \code{sources}, \code{reference_time},
#' and \code{elements}. The other function arguments are optional, and default
#' to \code{NULL}, which means that the response from the API is not
#' filtered on these parameters.
#'
#' @usage
#' get_observations(client_id,
#'                  sources,
#'                  reference_time,
#'                  elements,
#'                  maxage = NULL,
#'                  limit = NULL,
#'                  time_offsets = NULL,
#'                  time_resolutions = NULL,
#'                  time_series_ids = NULL,
#'                  performance_categories = NULL,
#'                  exposure_categories = NULL,
#'                  qualities = NULL,
#'                  levels = NULL,
#'                  include_extra = NULL,
#'                  fields = NULL,
#'                  return_response = FALSE)
#'
#' @param client_id A string. The client ID to use to send requests to the Frost
#' API.
#'
#' @param sources A character vector. The station IDs of the data sources
#' to get observations for. For example, "SN18700" is the station ID for
#' "Blindern". The full list of station IDs can be retrieved with
#' \code{\link{get_sources}()}.
#'
#' @param reference_time A string. The time range to get observations for in
#' either extended ISO-8601 format or the single word "latest".
#'
#' @param elements A character vector. The elements to get observations for.
#' The full list of elements can be retrieved with the
#' \code{\link{get_elements}()}.
#'
#' @param maxage A string. The maximum observation age as an ISO-8601 period,
#' e.g. \code{"P1D"}. This parameter is only applicable when \code{reference_time
#' = "latest"}. Defaults to "PT3H".
#'
#' @param limit A string or a positive integer. The maximum number of
#' observation times to be returned for each combination of source and
#' element, counting from the most recent time. This parameter is only
#' applicable when \code{reference_time = "latest"}. Set \code{limit = "all"}
#' to get all available times or a positive integer. Defaults to 1.
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
#' @param qualities A numeric vector. The qualities to get observations for as
#' a vector of integers, e.g. \code{c(1, 2)}.
#'
#' @param levels A numeric vector. The sensor levels to get observations for as
#' a vector of integers, e.g. \code{c(1, 2, 10, 20)}.
#'
#' @param include_extra An integer. If this parameter is set to 1, and extra
#' data is available, then this data is included in the response. Extra data
#' currently consists of the original observation value and the 16-character
#' control info.
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
#' @return The function returns either a data frame of historical weather
#' observations, or the response of the GET request, depending on the
#' boolean value set for \code{return_response}.
#'
#' @examples
#' \donttest{
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get daily data for temperature, rain, and wind speed for 2018
#' sources <- "SN18700"
#' reference.time <- "2018-01-01/2018-12-31"
#' elements <- c("mean(air_temperature P1D)",
#'               "sum(precipitation_amount P1D)",
#'               "mean(wind_speed P1D)")
#'
#' obs.df <- get_observations(client_id = client.id,
#'                            sources = sources,
#'                            reference_time = reference.time,
#'                            elements = elements)
#' }
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr stop_for_status
#' @importFrom httr user_agent
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @importFrom tidyr unnest
#' @export get_observations

get_observations <-
  function(
    client_id,
    sources,
    reference_time,
    elements,
    maxage = NULL,
    limit = NULL,
    time_offsets = NULL,
    time_resolutions = NULL,
    time_series_ids = NULL,
    performance_categories = NULL,
    exposure_categories = NULL,
    qualities = NULL,
    levels = NULL,
    include_extra = NULL,
    fields = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        sources               = frost_csl(sources),
        referencetime         = reference_time,
        elements              = frost_csl(elements),
        maxage                = maxage,
        limit                 = limit,
        timeoffsets           = frost_csl(time_offsets),
        timeresolutions       = frost_csl(time_resolutions),
        timeseriesids         = frost_csl(time_series_ids),
        performancecategories = frost_csl(performance_categories),
        exposurecategories    = frost_csl(exposure_categories),
        qualities             = frost_csl(qualities),
        levels                = frost_csl(levels),
        includeextra          = include_extra,
        fields                = frost_csl(fields)
        )

    frost_control_args(input_args = input_args, func = "get_observations")

    url <-
    paste0("https://", client_id, "@frost.met.no/observations/v0.jsonld",
           collapse = NULL)

    frostr_ua <- httr::user_agent("https://github.com/PersianCatsLikeToMeow/frostr")

    r <- httr::GET(url, query = input_args, frostr_ua)

    httr::stop_for_status(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

    obs_df <- tidyr::unnest(r_data, "observations")
    obs_df <- tibble::as_tibble(obs_df)

  }
