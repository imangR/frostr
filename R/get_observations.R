get_observations <-
  function(
    client_id,
    sources,
    reference_time,
    elements,
    maxage = NULL,
    limit = NULL,
    time_offsets = NULL,
    time_resolutions = NULL,
    time_series_ids = NULL,
    performance_categories = NULL,
    exposure_categories = NULL,
    qualities = NULL,
    levels = NULL,
    include_extra = NULL,
    fields = NULL
  ) {

    input_args <-
      list(
        "client_id"             = client_id,
        "sources"               = sources,
        "referencetime"         = reference_time,
        "elements"              = elements,
        "maxage"                = maxage,
        "limit"                 = limit,
        "timeoffsets"           = time_offsets,
        "timeresolutions"       = time_resolutions,
        "timeseriesids"         = time_series_ids,
        "performancecategories" = performance_categories,
        "exposurecategories"    = exposure_categories,
        "qualities"             = qualities,
        "levels"                = levels,
        "includeextra"          = include_extra,
        "fields"                = fields
        )

  # Define URL to get data from ---------------------------------------------

    url <-
    paste0(
      "https://", client_id, "@frost.met.no/observations/v0.jsonld",
      collapse = NULL
      )

    for (i in seq_along(input_args)[-1]) {
      if (!is.null(input_args[[i]])) {
        url <-
          urltools::param_set(url,
                              key = names(input_args[i]),
                              value = input_args[[i]])
      }
    }

# Get data ----------------------------------------------------------------

    get_request <-
      jsonlite::fromJSON(URLencode(url), flatten = TRUE)

    get_data <-
      get_request$data

# Coerce data into a data frame -------------------------------------------

    weather_df <-
      unnest(get_data, observations)

  }
