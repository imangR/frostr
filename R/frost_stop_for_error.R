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
