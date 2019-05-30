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
    fields = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        sources               = frost_csl(sources),
        referencetime         = reference_time,
        elements              = frost_csl(elements),
        maxage                = maxage,
        limit                 = limit,
        timeoffsets           = time_offsets,
        timeresolutions       = frost_csl(time_resolutions),
        timeseriesids         = frost_csl(time_series_ids),
        performancecategories = frost_csl(performance_categories),
        exposurecategories    = frost_csl(exposure_categories),
        qualities             = frost_csl(qualities),
        levels                = frost_csl(levels),
        includeextra          = include_extra,
        fields                = frost_csl(fields)
        )

    url <-
    paste0("https://", client_id, "@frost.met.no/observations/v0.jsonld",
           collapse = NULL)

    r <- httr::GET(url, query = input_args)

    stop_for_status(r)
    stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

    obs_df <- tidyr::unnest(r_data, observations)
    obs_df <- tibble::as_tibble(obs_df)

  }
