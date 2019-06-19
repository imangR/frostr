#' @title Get metadata for the location names defined in the Frost API
#'
#' @description \code{get_locations()} retrieves metadata about location names
#' defined for use in the Frost API. The function requires an
#' input for \code{client_id}. The other function arguments are optional, and
#' default to \code{NULL}, which means that the response from the API is not
#' filtered on these parameters.
#'
#' @usage
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
#' location names, or the response of the GET request, depending on the
#' boolean value set for \code{return_response}.
#'
#' @examples
#' \donttest{
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get all location names
#' locations.df <- get_locations(client_id = client.id)
#' }
#'
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
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
