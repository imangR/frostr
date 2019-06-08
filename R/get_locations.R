#' @title Get metadata for the location names defined in the Frost API
#'
#' @description \code{get_locations()} retrieves metadata about location names
#' defined for use in the Frost API. The function requires a client ID for the
#' \code{client_id} argument at minimum. Use the optional input arguments to
#' filter the set of location names returned in the response. The optional
#' function arguments default to NULL, which translates to no filter on the returned
#' response from the Frost API.
#'
#' @usage
#' get_locations(client_id, ...)
#'
#' get_locations(client_id,
#'               names = NULL,
#'               geometry = NULL,
#'               fields = NULL,
#'               return_response = FALSE)
#'
#' @param client_id A string. The client ID to use to send requests to the
#' Frost API.
#'
#' @param names A character vector. The location names that you want
#' metadata for.
#'
#' @param geometry A string. Get Frost API location names defined by a
#' specified geometry. Geometries are specified as either "nearest(POINT(...))"
#' or "POLYGON(...)" using well-known text representation for geometry (WKT).
#'
#' @param fields A character vector. A vector of the fields that should be
#' present in the response. If not set, then all fields will be retrieved.
#'
#' @param return_response A logical. If set to \code{TRUE}, then the function
#' returns the response from the GET request. If set to \code{FALSE} (default),
#' then the function returns a dataframe of the content in the response to the
#' GET request.
#'
#' @return The function returns either a data frame of locations, or the
#' response of the GET request for location resource in the Frost API,
#' depending on the value set for the \code{return_response} argument.
#'
#' @examples
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get data for all sources
#' locations <- get_locations(client_id = client.id)
#'
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom httr stop_for_status
#' @importFrom httr user_agent
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export get_locations

get_locations <-
  function(
    client_id,
    names = NULL,
    geometry = NULL,
    fields = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        names    = frost_csl(names),
        geometry = geometry,
        fields   = frost_csl(fields)
      )

    frost_control_args(input_args = input_args, func = "get_locations")

    url <-
      paste0("https://", client_id, "@frost.met.no/locations/v0.jsonld",
             collapse = NULL)

    frostr_ua <- httr::user_agent("https://github.com/PersianCatsLikeToMeow/frostr")

    r <- httr::GET(url, query = input_args)

    httr::stop_for_status(r)
    stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
