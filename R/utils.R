# Create an infix operator for the `frost_csl()` function

`%||%` <- function(lhs, rhs) {

  if (!is.null(lhs)) rhs
  else lhs

}

# Create a comma-separated list of the vector of inputs for
# some parameter
frost_csl <- function(parameter) {

  parameter <- unique(parameter)
  parameter %||% paste(parameter, collapse = ",")

}

# A control function for input arguments in `get_elements()`

frost_control_elements <- function() {



}

# A control function for input arguments in `get_sources()`

frost_control_sources <- function() {


}

stop_for_type <- function(x) {

  if (httr::http_type(x) != "application/json") {
    stop("The API request did not return content as JSON", call. = FALSE)
  }

}

# To convert frequency in `frost_get_obs` to a valid query input argument
frost_freq_to_query <- function(frequency) {



}


