# FROST STOP FOR TYPE ----
# Create a control function that throws an error if the response of the type
# is not of type JSON

frost_stop_for_type <- function(response) {
  if (httr::http_type(response) != "application/json") {
    stop("The API request did not return content as JSON", call. = FALSE)
  }
}
