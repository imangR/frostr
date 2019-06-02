#' @title Get data for source entities (i.e. stations) in the Frost API
#'
#' @description \code{get_sources()} retrieves data about source entities
#' (i.e. stations) that observe weather data.
#'
#' @usage
#' get_sources(client_id, ...)
#'
#' get_sources(client_id,
#'             ids = NULL,
#'             types = NULL,
#'             geometry = NULL,
#'             nearest_max_count = NULL,
#'             valid_time = NULL,
#'             name = NULL,
#'             country = NULL,
#'             county = NULL,
#'             municipality = NULL,
#'             wmo_id = NULL,
#'             station_holder = NULL,
#'             external_ids = NULL,
#'             icao_code = NULL,
#'             ship_code = NULL,
#'             wigos_id = NULL,
#'             fields = NULL,
#'             return_response = FALSE)
#'
#' @param client_id A string. The client ID to use to send requests to the
#' Frost API.
#'
#' @param ids A character vector. The Frost API source ID(s) that you want
#' metadata for the data sources.
#'
#' @param types A string. The type of Frost API source that you want
#' metadata for. Must be set to either "SensorSystem", "InterpolatedDataset",
#' or "RegionDataset". Defaults to \code{NULL}.
#'
#' @param geometry A string. Get Frost API sources defined by a specified
#' geometry. Geometries are specified as either "nearest(POINT(...))" or
#' "POLYGON(...)" using well-known text representation for geometry (WKT).
#'
#' @param nearest_max_count A string. The maximum number of sources returned
#' when using "nearest(POINT(...))" for \code{geometry}. Defaults to 1 if
#' not specified.
#'
#' @param valid_time A string. The time interval for which the sources have
#' been or still are valid (or applicable). Specify as "<date>/<date>" or
#' "<date>/now" where <date> is a date in the ISO-8601 format (YYYY-MM-DD).
#' Defaults to "now" if not specified, which returns only currently valid
#' sources.
#'
#' @param name A string. If specified, the request will return a response
#' filtered on sources with matching names to that specified in \code{name}.
#'
#' @param country A string. If specified, the request will return a response
#' filtered on sources with matching country or country codes to that specified
#' in \code{country}.
#'
#' @param county A string. If specified, the request will return a response
#' filtered on sources with matching county or county ID to that specified in
#' \code{county}.
#'
#' @param municipality A string. If specified, the request will return a
#' response filtered on sources with matching municipality or municipality
#' ID to that specified in \code{municipality}.
#'
#' @param wmo_id A string. If specified, the request will return a response
#' filtered on sources with matching wmo ID to that specified in \code{wmoid}.
#'
#' @param station_holder A string. If specified, the request will return a
#' response filtered on sources with matching station holder names to that
#' specified in \code{station_holder}.
#'
#' @param external_ids A character vector. If specified, the request will
#' return a response filtered on sources with matching external ids to that
#' specified in \code{station_holder}.
#'
#' @param icao_code A string. If specified, the request will return a response
#' filtered on sources with matching ICAO codes to that specified in
#' \code{icao_code}.
#'
#' @param ship_code A string. If specified, the request will return a response
#' filtered on sources with matching ship codes to that specified in
#' \code{ship_code}.
#'
#' @param wigos_id A string. If specified, the request will return a response
#' filtered on sources with matching WIGOS ids to that specified in
#' \code{wigos_id}.
#'
#' @param fields A character vector. A vector of the fields that should be
#' present in the response. If not set, then all fields will be retrieved.
#'
#' @param return_response A logical. If set to \code{TRUE}, then the function
#' returns the response from the GET request. If set to \code{FALSE} (default),
#' then the function returns a dataframe of the content in the response to the
#' GET request.
#'
#' @return The function returns either a data frame with metadata about sources
#' or the response of the GET request for the sources, depending on the value
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

get_sources <-
  function(
    client_id,
    ids = NULL,
    types = NULL,
    geometry = NULL,
    nearest_max_count = NULL,
    valid_time = NULL,
    name = NULL,
    country = NULL,
    county = NULL,
    municipality = NULL,
    wmoid = NULL,
    station_holder = NULL,
    external_ids = NULL,
    icao_code = NULL,
    ship_code = NULL,
    wigos_id = NULL,
    fields = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        ids             = frost_csl(ids),
        types           = types,
        geometry        = geometry,
        nearestmaxcount = nearest_max_count,
        validtime       = valid_time,
        name            = name,
        country         = country,
        county          = county,
        municipality    = municipality,
        wmoid           = wmoid,
        stationholder   = station_holder,
        externalids     = frost_csl(external_ids),
        icaocode        = icao_code,
        shipcode        = ship_code,
        wigosid         = wigos_id,
        fields          = frost_csl(fields)
      )

    frost_control_sources(input_args = input_args)

    url <-
      paste0("https://", client_id, "@frost.met.no/sources/v0.jsonld",
             collapse = NULL)

    r <- httr::GET(url, query = input_args)

    httr::stop_for_status(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }

