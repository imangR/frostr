#' @title Get metadata about the weather and climate elements that are
#' defined in the Frost API
#'
#' @description \code{get_elements()} retrieves metadata about weather and
#' climate elements defined for use in the Frost API. The function requires an
#' input for \code{client_id}. The other function arguments are optional, and
#' default to \code{NULL}, which means that the response from the API is not
#' filtered on these parameters.
#'
#' @usage
#' get_elements(client_id,
#'              ids = NULL,
#'              names = NULL,
#'              descriptions = NULL,
#'              units = NULL,
#'              code_tables= NULL,
#'              statuses = NULL,
#'              calculation_method = NULL,
#'              categories = NULL,
#'              time_offsets = NULL,
#'              sensor_levels = NULL,
#'              old_element_codes = NULL,
#'              old_units = NULL,
#'              cf_standard_names = NULL,
#'              cf_cell_methods = NULL,
#'              cf_units = NULL,
#'              cf_versions = NULL,
#'              fields = NULL,
#'              language = NULL,
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
#' @param code_tables A character vector. The code tables to get metadata for.
#'
#' @param statuses A character vector. The statuses to get metadata for.
#'
#' @param calculation_method A string. The calculation method as a JSON filter.
#' Supports the following keys: baseNames, methods, innerMethods, periods,
#' innerPeriods, thresholds, methodDescriptions, innerMethodDescriptions,
#' methodUnits, and innerMethodUnits.
#'
#' @param categories A character vector. The categories to get metadata for.
#'
#' @param time_offsets A character vector. The time offsets to get metadata for.
#'
#' @param sensor_levels A string. The sensor levels to get metadata
#' for as a JSON filter. Supports the following keys: levelTypes, units,
#' defaultValues, and values.
#'
#' @param old_element_codes A character vector. The old MET Norway element codes
#' to get metadata for.
#'
#' @param old_units A character vector. The old MET Norway units to get
#' metadata for.
#'
#' @param cf_standard_names A character vector. The CF standard names to get
#' metadata for.
#'
#' @param cf_cell_methods A character vector. The CF cell methods to get
#' metadata for.
#'
#' @param cf_units A character vector. The CF units to get metadata for.
#'
#' @param cf_versions A character vector. The CF versions to get metadata for.
#'
#' @param fields A character vector. Fields to include in the response (i.e.
#' output). If this parameter is specified, then only these fields are
#' returned in the response. If not specified, then all fields will be
#' returned in the response.
#'
#' @param language A string. The language of the fields in the response. The
#' options are "en-US" (default), "nb-NO" (Norwegian, Bokmål), and "nn-NO"
#' (Norwegian, Nynorsk).
#'
#' @param return_response A logical. If set to \code{TRUE}, then the function
#' returns the response from the GET request. If set to \code{FALSE} (default),
#' then the function returns a tibble (data frame) of the content in the
#' response.
#'
#' @return The function returns either a data frame with metadata about
#' climate and weather elements, or the response of the GET request, depending
#' on the boolean value set for \code{return_response}.
#'
#' @examples
#' \donttest{
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get data for all elements
#' elements.df <- get_elements(client_id = client.id)
#' }
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
    language = NULL,
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
        fields            = frost_csl(fields),
        lang              = language
      )

    frost_control_args(input_args = input_args, func = "get_elements")

    url <-
      paste0("https://", client_id, "@frost.met.no/elements/v0.jsonld",
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
