context("Function output classes")

library(frostr)

client.id <- Sys.getenv("frost_client_id")
sources <- "SN18700"
elements <- c("mean(air_temperature P1D)", "sum(precipitation_amount P1D)")
reference.time <- "2019-01-01/2019-01-02"

obs.df  <- get_observations(client.id, sources, reference.time, elements)
src.df  <- get_sources(client.id)
ele.df  <- get_elements(client.id)
loc.df  <- get_locations(client.id)
ts.df   <- get_available_timeseries(client.id, sources)
qc.df   <- get_available_qualitycodes(client.id)
ct.df   <- get_element_codetables(client.id)

qc.df.summary <- get_available_qualitycodes(client.id, fields = "summarized")
qc.df.details <- get_available_qualitycodes(client.id, fields = "details")

test_that("functions return the correct classes with minimal input arguments", {
  expect_equal(class(obs.df),        c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(src.df),        c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(ele.df),        c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(loc.df),        c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(ts.df),         c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(qc.df),         c("list"))
  expect_equal(class(qc.df.summary), c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(qc.df.details), c("tbl_df", "tbl", "data.frame"))
  expect_equal(class(ct.df),         c("tbl_df", "tbl", "data.frame"))
  })
