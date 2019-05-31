#' @title Get historical weather observations from the Frost API
#'
#' @description \code{get_observations()} retrieves historical weather data from
#'   the Frost API.
#'
#' @usage \code{get_observations(client_id, sources, reference_time, elements,
#'   ...)}
#'
#' @param client_id A string. The client ID to use to send requests to the Frost
#'   API.
#'
#' @param sources A character vector. The IDs of the data sources (i.e.
#'   stations) that observed the weather data.
#'
#' @param reference_time A string. The time range to get observations for in
#'   either extended ISO-8601 format or the single word "latest".
#'
#' @param elements A character vector. The elements to get observations for.
#'   Available elements can be retrieved with the \code{get_elements()}
#'   function.
#'
#' @param maxage A string. The maximum observation age as an ISO-8601 period,
#'   such as "P1D". This parameter is only applicable when \code{reference_time
#'   = "latest"}. The default value is "PT3H".
#'
#' @param limit A string or a positive integer. The maximum number of
#'   observation times to be returned for each combination of source and
#'   element, counting from the most recent time. This parameter is only
#'   applicable when \code{reference_time = "latest"}. Set \code{limit = "all"}
#'   to get all available times or a positive integer. The default value is 1.
#'
#' @param time_offsets A character vector. The time offsets to get observations
#'   for provided as a vector of ISO-8601 periods. If the parameter is not set,
#'   then the response (i.e. output) is not filtered on time offsets.
#'
#' @param time_resolutions A character vector. The time resolutions to get
#'   observations for provided as a vector of ISO-8601 periods. If the parameter
#'   is not set, then the response (i.e. output) is not filtered on time
#'   resolutions.
#'
#' @param time_series_ids A numeric vector. The internal time series IDs to get
#'   observations for as a vector of integers. If the parameter is not set, then
#'   the response (i.e. output) is not filtered on internal time series ID.
#'
#' @param performance_categories A character vector. The performance categories
#'   to get observations for as a vector of letters, e.g. "A", "C". If the
#'   parameter is not set, then the response (i.e. output) is not filtered on
#'   internal time series ID.
#'
#' @param exposure_categories A numeric vector. The exposure categories to get
#'   observations for as a vector of integers. If the parameter is not set, then
#'   the response (i.e. output) is not filtered on exposure categories.
#'
#' @param qualities A numeric vector. The qualities to get observations for as a
#'   vector of integers. If the parameter is not set, then the response (i.e.
#'   output) is not filtered on quality.
#'
#' @param levels A numeric vector. The sensor levels to get observations for as
#'   a vector of integers. If the parameter is not set, then the response (i.e.
#'   output) is not filtered on sensor level.
#'
#' @param include_extra A logical or integer. If this parameter is set to 1
#' or \code{TRUE}, and extra data is available, then this data is included
#' in the response. Extra data currently consists of the original observation
#' value and the 16-character control info.
#'
#' @param fields A character vector. Fields to include in the response (i.e.
#'   output). If this parameter is specified, then only these fields are
#'   returned in the response. If not specified, then all fields will be
#'   returned in the response.
#'
#' @param return_response A logical. If set to \code{TRUE}, then the function
#'   returns the response from the GET request. If set to \code{FALSE}, then the
#'   function returns a dataframe of the content in the response to the GET
#'   request.
#'
#' @return The function returns either a data frame of historical weather
#' observations or the response of the GET request for the observations,
#' depending on the value set for the \code{return_response} argument.
#'
#' @examples
#' # Get daily data for temperature, rain, and wind speed for 2018
#' client.id <- "<YOUR CLIENT ID>"
#' sources <- "SN18700"
#' reference.time <- "2018-01-01/2018-12-31"
#' elements <- c("mean(air_temperature P1D)",
#'               "sum(precipitation_amount P1D)",
#'               "mean(wind_speed P1D)")
#'
#' observations_df <- get_observations(client_id = client.id,
#'                                     sources = sources,
#'                                     reference_time = reference.time,
#'                                     elements)
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr stop_for_status
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

    # Insert input argument control function ----

    input_args <-
      list(
        sources               = frost_csl(sources),
        referencetime         = reference_time,
        elements              = frost_csl(elements),
        maxage                = maxage,
        limit                 = limit,
        timeoffsets           = time_offsets,
        timeresolutions       = frost_csl(time_resolutions),
        timeseriesids         = frost_csl(time_series_ids),
        performancecategories = frost_csl(performance_categories),
        exposurecategories    = frost_csl(exposure_categories),
        qualities             = frost_csl(qualities),
        levels                = frost_csl(levels),
        includeextra          = as.integer(include_extra),
        fields                = frost_csl(fields)
        )

    url <-
    paste0("https://", client_id, "@frost.met.no/observations/v0.jsonld",
           collapse = NULL)

    r <- httr::GET(url, query = input_args)

    frost_stop_for_error(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

    obs_df <- tidyr::unnest(r_data, observations)
    obs_df <- tibble::as_tibble(obs_df)

  }
