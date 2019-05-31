get_sources <-
  function(
    client_id,
    ids = NULL,
    types = NULL,
    geometry = NULL,
    nearest_max_count = NULL,
    valid_time = NULL,
    name = NULL,
    country = NULL,
    county = NULL,
    municipality = NULL,
    wmoid = NULL,
    station_holder = NULL,
    external_ids = NULL,
    icao_code = NULL,
    ship_code = NULL,
    wigos_id = NULL,
    fields = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        ids             = frost_csl(ids),
        types           = types,
        geometry        = geometry,
        nearestmaxcount = nearest_max_count,
        validtime       = valid_time,
        name            = name,
        country         = country,
        county          = county,
        municipality    = municipality,
        wmoid           = wmoid,
        stationholder   = station_holder,
        externalids     = external_ids,
        icaocode        = icao_code,
        shipcode        = ship_code,
        wigosid         = wigos_id,
        fields          = frost_csl(fields)
      )

    url <-
      paste0("https://", client_id, "@frost.met.no/sources/v0.jsonld",
             collapse = NULL)

    r <- httr::GET(url, query = input_args)

    frost_stop_for_error(r)
    frost_stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
