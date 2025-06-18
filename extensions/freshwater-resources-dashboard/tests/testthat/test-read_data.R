box::use(
  testthat[...],
  checkmate[expect_data_frame]
)

box::use(
  app/logic/read_data[complete_data]
)

test_that("check complete_data", {
  expect_data_frame(
    complete_data,
    min.rows = 1,
    types = c("character", "numeric", "numeric", "numeric"),
    ncols = 4,
    col.names = "named"
  )
})
