#' @title Get metadata about the weather and climate elements that are
#' defined for use in the Frost API
#'
#' @description \code{get_elements()} retrieves metadata about weather and
#' climate elements defined for use in the Frost API. The function requires a
#' client ID for the \code{client_id} argument at minimum. Use the optional
#' input arguments to filter the set of elements returned in the response.
#' The optional function arguments default to NULL, which translates to no
#' filter on the returned response from the Frost API.
#'
#' @usage
#' get_elements(client_id, ...)
#'
#' get_elements(client_id,
#'              ids = NULL,
#'              names = NULL,
#'              descriptions = NULL,
#'              units = NULL,
#'              codeTables= NULL,
#'              statuses = NULL,
#'              calculationMethod = NULL,
#'              categories = NULL,
#'              timeOffsets = NULL,
#'              sensorLevels = NULL,
#'              oldElementCodes = NULL,
#'              oldUnits = NULL,
#'              cfStandardNames = NULL,
#'              cfCellMethods = NULL,
#'              cfUnits = NULL,
#'              cfVersions = NULL,
#'              fields = NULL,
#'              return_response = FALSE)
#'
#' @param client_id A string. The client ID to use to send requests to the
#' Frost API.
#'
#' @param ids A character vector. The element IDs to get metadata for.
#'
#' @param names A character vector. The element names to get metadata for.
#'
#' @param descriptions A character vector. The descriptions to get metadata
#' for.
#'
#' @param units A character vector. The units to get metadata for.
#'
#' @param codeTables A character vector. The code tables to get metadata for.
#'
#' @param statuses A character vector. The statuses to get metadata for.
#'
#' @param calculationMethod A string. The calculation method as a JSON filter.
#' Supports the following keys: baseNames, methods, innerMethods, periods,
#' innerPeriods, tresholds, methodDescriptions, innerMethodDescriptions,
#' methodUnits, and innerMethodUnits.
#'
#' @param categories A character vector. The categories to get metadata for.
#'
#' @param timeOffsets A character vector. The time offsets to get metadata for.
#'
#' @param sensorLevels A string. The sensor levels to get metadata
#' for as a JSON filter. Supports the following keys: levelTypes, units,
#' defaultValues, and values.
#'
#' @param oldElementCodes A character vector. The old MET Norway element codes
#' to get metadata for.
#'
#' @param oldUnits A character vector. The old MET Norway units to get
#' metadata for.
#'
#' @param cfStandardNames A character vector. The CF standard names to get
#' metadata for.
#'
#' @param cfCellMethods A character vector. The CF cell methods to get
#' metadata for.
#'
#' @param cfUnits A character vector. The CF units to get metadata for.
#'
#' @param cfVersions A character vector. The CF versions to get metadata for.
#'
#' @param fields A character vector. A vector of the fields that should be
#' present in the response. If not set, then all fields will be retrieved.
#'
#' @param return_response A logical. If set to \code{TRUE}, then the function
#' returns the response from the GET request. If set to \code{FALSE} (default),
#' then the function returns a dataframe of the content in the response to the
#' GET request.
#'
#' @return The function returns either a data frame of weather and climate
#' elements, or the response of the GET request for location resource in
#' the Frost API, depending on the value set for the \code{return_response}
#' argument.
#'
#' @examples
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get data for all elements
#' elements <- get_elements(client_id = client.id)
#'
#' @export get_elements

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

    frost_control_args(input_args = input_args, func = "get_elements")

    url <-
      paste0("https://", client_id, "@frost.met.no/elements/v0.jsonld?lang=en-US",
             collapse = NULL)

    r <- httr::GET(url, query = input_args)

    test_url <- modify_url(paste0("https://", client_id, "@frost.met.no"), path = "elements/v0.jsonld?lang=en-US")

    httr::stop_for_status(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
