#' @title Get metadata about code tables for the "elements" resource
#'
#' @description \code{get_element_codetables()} retrieves metadata about
#' code tables. A code table defines a small number of discrete values for
#' an element. The function requires input for \code{client_id}. The other
#' function arguments are optional, and default to \code{NULL}, which means
#' that the response from the API is not filtered on these parameters.
#'
#' @usage
#' get_element_codetables(client_id,
#'                        ids = NULL,
#'                        fields = NULL,
#'                        language = NULL,
#'                        return_response = FALSE)
#'
#' @param client_id A string. The client ID to use to send requests to the
#' Frost API.
#'
#' @param ids A character vector. The element IDs to get metadata for.
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
#' @param return_response A logical. If set to \code{TRUE}, then the function
#' returns the response from the GET request. If set to \code{FALSE} (default),
#' then the function returns a tibble (data frame) of the content in the
#' response.
#'
#' @return The function returns either a data frame with metadata about code
#' tables, or the response of the GET request, depending on the boolean value
#' set for \code{return_response}.
#'
#' @examples
#' \donttest{
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get the full code table
#' code.tables <- get_element_codetables(client_id = client.id)
#' }
#'
#' @export get_element_codetables

get_element_codetables <-
  function(
    client_id,
    ids = NULL,
    fields = NULL,
    language = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        ids    = frost_csl(ids),
        fields = frost_csl(fields),
        lang   = language
      )

    frost_control_args(input_args = input_args, func = "get_element_codetables")

    url <-
      paste0("https://", client_id, "@frost.met.no/elements/codeTables/v0.jsonld",
             collapse = NULL)

    r <- httr::GET(url, query = input_args)

    httr::stop_for_status(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
