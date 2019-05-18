# Library needed (jsonlite must be installed in R)
library(jsonlite)

# Insert your own client ID here
client_id <- '<INSERT CLIENT ID HERE>'

# Define andpoint and parameters
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

# Issue an HTTP GET request and extract JSON data
xs <- try(fromJSON(URLencode(url),flatten=T))

# Check if the request worked, print out any errors
if (class(xs) != 'try-error') {
  print("Data retrieved from frost.met.no!")
  data <- xs$data
} else {
  print("Error: the data retrieval was not successful!")
}

# This will return a Dataframe with all of the observations in a table format
df <- data.frame()
for (i in 1:length(data$observations)) {
  row <- data$observations[[i]]
  row$sourceId <- data$sourceId[[i]]
  row$referenceTime <- data$referenceTime[[i]]
  df <- rbind(df, row)
}

head(df)

# These additional columns will be kept
columns <- c("sourceId","referenceTime","elementId","value","unit","timeOffset")
df2 <- df[columns]

# Convert the time value to something R understands
df2$referenceTime <- as.Date(df2$referenceTime)

head(df2)
