context("mspm package options")

test_that("function: handle_options is defined", {
  expect_false(identical(find("handle_options"), character(0)))
})

test_that("function: handle_options can set and query options", {
  mspm::handle_options("test" = "value")
  expect_equal(mspm::handle_options("test"), "value")
  # the value remains in the environment after the test
  # we need to remove it again.
  # ls.str(.mspm.env)
  # rm("test", envir = )
})
