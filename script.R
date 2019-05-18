# Define andpoint and parameters
client_id <- "dummy123"
endpoint <- paste0("https://", client_id, "@frost.met.no/observations/v0.jsonld", collapse=NULL)
sources <- 'SN18700,SN90450'
elements <- 'mean(air_temperature P1D),sum(precipitation_amount P1D),mean(wind_speed P1D)'
referenceTime <- '2010-04-01/2010-04-03'
# Build the URL to Frost
url <- paste0(
  endpoint, "?",
  "sources=", sources,
  "&referencetime=", referenceTime,
  "&elements=", elements,
  collapse=NULL
)