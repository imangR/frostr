# Create an infix operator for the `frost_csl()` function

`%||%` <- function(lhs, rhs) {

  if (!is.null(lhs)) rhs
  else lhs

}

# FROST CSL ----
# Create a comma-separated list of the vector of inputs for
# some parameter

frost_csl <- function(parameter) {

  parameter <- unique(parameter)
  parameter %||% paste(parameter, collapse = ",")

}

# A control function for input arguments in `get_elements()`

frost_control_elements <- function() {



}

# FROST CONTROL SOURCES ----
# A control function for input arguments in `get_sources()`

frost_control_sources <- function() {

  # ids ----

  if (typeof(ids) != "character") {

    stop("`ids` must be a vector of type `character`. You have insert a vector ",
         "of type ", "`", typeof(ids), "`",
         call. = FALSE)

  }

  # types ----

  if (typeof(types) != "character") {

    stop("`types` must be a vector of type `character`. You have insert a vector ",
         "of type ", "`", typeof(types), "`.",
         call. = FALSE)

  } else if (length(types) != 1) {

    stop("The length of `types` must be equal to 1. You have insert a vector ",
         "of length ", length(types), ".",
         call. = FALSE)

  }

  # geometry ----

  if (typeof(geometry) != "character") {

    stop("`geometry` must be a vector of type `character`. You have insert a vector ",
         "of type ", "`", typeof(geometry), "`.",
         call. = FALSE)

  } else if (length(geometry) != 1) {

    stop("The length of `geometry` must be equal to 1. You have insert vector ",
         "of length ", length(geometry), ".",
         call. = FALSE)

  }

  # nearest_max_count ----

  if (typeof(nearest_max_count) != "double" | typeof(nearest_max_count) != "integer") {

    stop("`nearest_max_count` must be a vector of type `double` or `integer`. ",
         "You have insert a vector of type ", "`", typeof(nearest_max_count), "`.",
         call. = FALSE)

  } else if(length(nearest_max_count) != 1) {

    stop("The length of `nearest_max_count` must be equal to 1. You have insert vector ",
         "of length ", length(nearest_max_count), ".",
         call. = FALSE)

  }

  # valid_time ----

  if (typeof(valid_time) != "character") {

    stop("`valid_time` must be a vector of type `character`. You have insert a vector ",
         "of type ", "`", typeof(validtime), "`.",
         call. = FALSE)

  } else if (length(valid_time) != 1) {

    stop("The length of `valid_time` must be equal to 1. You have insert vector ",
         "of length ", length(validtime), ".",
         call. = FALSE)

  }

  if (typeof(name) != "character") {

    stop("`valid_time` must be a vector of type `character`. You have insert a vector ",
         "of type ", "`", typeof(validtime), "`.",
         call. = FALSE)

  }
}

# FROST STOP FOR TYPE ----
# Create a control function that throws an error if the response of the type
# is not of type JSON

frost_stop_for_type <- function(response) {
  if (httr::http_type(response) != "application/json") {
    stop("The API request did not return content as JSON", call. = FALSE)
  }
}

# FROST STOP FOR ERROR ----
# Create a control function that throws an error if the status code of the
# response is one of the Frost API's specified error status codes

frost_stop_for_error <- function(response) {
  if (httr::status_code(response) == 400) {
    stop("Invalid parameter value or malformed request (HTTP 400).", call. = FALSE)
  } else if (httr::status_code(response) == 401) {
    stop("Unauthorized client ID (HTTP 401).", call. = FALSE)
  } else if (httr::status_code(response) == 403) {
    stop("Too many observations requested (HTTP 403).", call. = FALSE)
  } else if (httr::status_code(response) == 404) {
    stop("No data was found for the query parameters (HTTP 404).", call. = FALSE)
  } else if (httr::status_code(response) == 412) {
    stop("No available time series for the query parameters (HTTP 412).", call. = FALSE)
  } else if (httr::status_code(response) == 429) {
    stop("The service is busy. There are too many requests in progress (HTTP 429).", call. = FALSE)
  } else if (httr::status_code(response) == 500) {
    stop("Internal server error (HTTP 500).", call. = FALSE)
  } else if (httr::status_code(response) == 503) {
    stop("The service is busy. There are too many requests in progress (HTTP 503).", call. = FALSE)
  }
}

# To convert frequency in `frost_get_obs` to a valid query input argument
frost_freq_to_query <- function(frequency) {

}

#


