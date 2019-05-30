frost_get_obs <- function(client_id, elements, location, from, to, frequency) {

  sources <- get_sources(client_id = client_id,
                         name = paste0("*", location, "*"),
                         country = "<Some country name in English")
  ids <- sources$id

  reference.time <- paste0(from, to, sep = "/")

  time.offsets <- frost_freq_to_query(frequency)

  obs <- get_observations(client_id = client.id,
                          sources = ids,
                          elements = elements,
                          reference_time = reference.time)

}
