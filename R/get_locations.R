#' @title Get metadata for the location names defined in the Frost API
#'
#' @description \code{get_locations()} retrieves metadata about locations
#' in the Frost API. Use the optional input arguments to filter the set of
#' locations returned in the response.
#'
#' @usage
#' get_sources(client_id, ...)
#'
#' get_sources(client_id,
#'             names = NULL,
#'             geometry = NULL,
#'             fields = NULL,
#'             return_response = FALSE)
#'
#' @param client_id A string. The client ID to use to send requests to the
#' Frost API.
#'
#' @param names A character vector. The Frost API source ID(s) that you want
#' metadata for the data sources.
#'
#' @param geometry A string. Get Frost API sources defined by a specified
#' geometry. Geometries are specified as either "nearest(POINT(...))" or
#' "POLYGON(...)" using well-known text representation for geometry (WKT).
#'
#' @param fields A string. Get Frost API sources defined by a specified
#' geometry. Geometries are specified as either "nearest(POINT(...))" or
#' "POLYGON(...)" using well-known text representation for geometry (WKT).
#'
#' @return The function returns either a data frame of sources or the
#' response of the GET request for the sources, depending on the value
#' set for the \code{return_response} argument.
#'
#' @examples
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get data for all sources
#' sources <- get_sources(client_id = client.id)
#'
#' # Get data for sources in Norway
#' sources_norway <- get_sources(client.id = client.id,
#'                               country = "NO")
#'

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

    url <-
      paste0("https://", client_id, "@frost.met.no/locations/v0.jsonld",
             collapse = NULL)

    r <- httr::GET(url, query = input_args)

    stop_for_status(r)
    stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
