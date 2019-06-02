#' @title Get metadata about the weather and climate elements that are
#' defined for use in the Frost API
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
#' @param ids
#'
#' @param names
#'
#' @param descriptions
#'
#' @param units
#'
#' @param codeTables
#'
#' @param statuses
#'
#' @param calculationMethod
#'
#' @param categories
#'
#' @param timeOffsets
#'
#' @param sensorLevels
#'
#' @param oldElementCodes
#'
#' @param oldUnits
#'
#' @param cfStandardNames
#'
#' @param cfCellMethods
#'
#' @param cfUnits
#'
#' @param cfVersions
#'
#' @param fields
#'
#' @param return_response
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
get_elements <-
  function(
    client_id,
    ids = NULL,
    names = NULL,
    descriptions = NULL,
    units = NULL,
    code_tables = NULL,
    statuses = NULL,
    calculation_method = NULL,
    categories = NULL,
    time_offsets = NULL,
    sensor_levels = NULL,
    old_element_codes = NULL,
    old_units = NULL,
    cf_standard_names = NULL,
    cf_cell_methods = NULL,
    cf_units = NULL,
    cf_versions = NULL,
    fields = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        ids               = frost_csl(ids),
        names             = frost_csl(names),
        descriptions      = frost_csl(descriptions),
        units             = frost_csl(units),
        codeTables        = frost_csl(code_tables),
        statuses          = frost_csl(statuses),
        calculationMethod = calculation_method,
        categories        = frost_csl(categories),
        timeOffsets       = frost_csl(time_offsets),
        sensorLevels      = sensor_levels,
        oldElementCodes   = frost_csl(old_element_codes),
        oldUnits          = frost_csl(old_units),
        cfStandardNames   = frost_csl(cf_standard_names),
        cfCellMethods     = frost_csl(cf_cell_methods),
        cfUnits           = frost_csl(cf_units),
        cfVersions        = frost_csl(cf_versions),
        fields            = frost_csl(fields)
      )

    frost_control_args(input_args = input_args, func == "get_elements")

    url <-
      paste0("https://", client_id, "@frost.met.no/elements/v0.jsonld?lang=en-US",
             collapse = NULL)

    r <- httr::GET(url, query = input_args)

    test_url <- modify_url(paste0("https://", client_id, "@frost.met.no"), path = "elements/v0.jsonld?lang=en-US")

    httr::stop_for_error(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
