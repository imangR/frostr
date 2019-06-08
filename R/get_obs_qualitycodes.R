#' @title Get metadata about existing quality flags for observations
#'
#' @description \code{get_obs_qualitycodes()} provides a data frame with all
#' possible detail values given the quality service. The function requires
#' input for \code{client_id}. The other function arguments are optional, and default
#' to \code{NULL}, which means that the response from the API is not
#' filtered on these parameters.
#'
#' @usage
#' get_obs(client_id, sources, reference_time, elements, ...)
#'
#' get_obs(client_id,
#'         sources,
#'         reference_time,
#'         elements,
#'         maxage = NULL,
#'         limit = NULL,
#'         time_offsets = NULL,
#'         time_resolutions = NULL,
#'         time_series_ids = NULL,
#'         performance_categories = NULL,
#'         exposure_categories = NULL,
#'         qualities = NULL,
#'         levels = NULL,
#'         include_extra = NULL,
#'         fields = NULL,
#'         return_response = FALSE)
#'
#' @param client_id A string. The client ID to use to send requests to the Frost
#' API.
#'
#' @param fields A character vector. The field to include in the response (i.e.
#' output). If this parameter is set, then only the specified field is
#' returned as a data frame. If not set, then all fields will be
#' returned in the response as a list. The options are "summarized" and
#' "details".
#'
#' @param language A string. The language of the fields in the response. The
#' options are "en-US" (default), "nb-NO" (Norwegian, Bokmål), and "nn-NO"
#' (Norwegian, Nynorsk).
#'
#'
#' @param return_response A logical. If set to \code{TRUE}, then the function
#' returns the response from the GET request. If set to \code{FALSE}, then the
#' function returns a dataframe of the content in the response to the GET
#' request.
#'
#' @return The function returns either a data frame of historical weather
#' observations or the response of the GET request for the observations,
#' depending on the value set for the \code{return_response} argument.
#'
#' @examples
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get metadata for quality codes
#' qualitycodes_df <- get_obs_qualitycodes(client_id = client.id)
#'
#' # Get the summarized metadata for quality codes
#' summarized_df <- get_obs_qualitycodes(client_id = client.id,
#'                                       fields = "summarized")
#'

get_obs_qualitycodes <-
  function(
    client_id,
    fields = NULL,
    language = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        fields = fields,
        lang   = language
      )

    frost_control_args(input_args = input_args, func = "get_obs_qualitycodes")

    url <-
      paste0("https://", client_id,
             "@frost.met.no/observations/availableQualityCodes/v0.jsonld",
             collapse = NULL)

    frostr_ua <- httr::user_agent("https://github.com/PersianCatsLikeToMeow/frostr")

    r <- httr::GET(url, query = input_args, frostr_ua)

    httr::stop_for_status(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    if (is.null(fields)) {

      r_data <- r_json[["data"]]

    }

    else if (fields == "summarized") {

      r_data <- tibble::as_tibble(r_json[["data"]][[fields]])

    } else if (fields == "details") {

      r_data <- tibble::as_tibble(r_json[["data"]][[fields]])

    } else {

      warning("You have input ", "\"", fields, "\"", " for `fields`, which is ",
           "invalid. `fields` must be either \"summarized\" or \"details\".",
           " \n\n...Returning the response from the GET request.",
           call. = FALSE)

      r

    }
  }
