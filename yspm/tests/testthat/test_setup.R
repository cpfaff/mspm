context("Setup project management")

test_that("function: setup is defined ", {
  expect_false(identical(find('setup'), character(0)))
})

test_that("function: setup accepts required parameters", {
  expect_true(all(names(formals("setup")) %in% c("root_path")))
})

