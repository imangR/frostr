#' @title Get metadata on existing quality flags in the "observation" resource
#'
#' @description \code{get_available_qualitycodes()} provides a data frame with all
#' possible detail values given the quality service. The function requires
#' input for \code{client_id}. The other function arguments are optional, and default
#' to \code{NULL}, which means that the response from the API is not
#' filtered on these parameters.
#'
#' @usage
#' get_available_qualitycodes(client_id,
#'                            fields = NULL,
#'                            language = NULL,
#'                            return_response = FALSE)
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
#' @param return_response A logical. If set to \code{TRUE}, then the function
#' returns the response from the GET request. If set to \code{FALSE} (default),
#' then the function returns a tibble (data frame) of the content in the
#' response.
#'
#' @return The function returns either a data frame with metadata about
#' quality flags, or the response of the GET request, depending
#' on the boolean value set for \code{return_response}.
#'
#' @examples
#' \donttest{
#' client.id <- "<YOUR CLIENT ID>"
#'
#' # Get metadata for quality codes
#' qualitycodes <- get_available_qualitycodes(client_id = client.id)
#'
#' # Get the summarized metadata for quality codes
#' summarized.df <- get_available_qualitycodes(client_id = client.id,
#'                                             fields = "summarized")
#' }
#'
#' @export get_available_qualitycodes

get_available_qualitycodes <-
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

    frost_control_args(input_args = input_args, func = "get_available_qualitycodes")

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
