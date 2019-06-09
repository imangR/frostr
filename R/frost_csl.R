# FROST INFIX OPERATOR ----
# Create an infix operator for the `frost_csl()` function

`%||%` <- function(lhs, rhs) {
  if (!is.null(lhs)) rhs
  else lhs
}

# FROST CSL ----
# Create a comma-separated list of the vector of inputs for some parameter

frost_csl <- function(parameter) {
  parameter <- unique(parameter)
  parameter %||% paste(parameter, collapse = ",")
}
