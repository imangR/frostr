get_locations <-
  function(
    client_id,
    names = NULL,
    geometry = NULL,
    fields = NULL,
    return_response = FALSE
  ) {

    input_args <-
      list(
        names    = frost_csl(names),
        geometry = geometry,
        fields   = frost_csl(fields)
      )

    url <-
      paste0("https://", client_id, "@frost.met.no/locations/v0.jsonld",
             collapse = NULL)

    r <- httr::GET(url, query = input_args)

    stop_for_status(r)
    stop_for_type(r)

    if (return_response) return(r)

    r_content <- httr::content(r, as = "text", encoding = "UTF-8")
    r_json <- jsonlite::fromJSON(r_content, flatten = TRUE)

    r_data <- tibble::as_tibble(r_json[["data"]])

  }
