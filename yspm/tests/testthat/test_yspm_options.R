context("yspm package options")

test_that("function: project_structure is defined", {
  expect_false(identical(find("project_structure"), character(0)))
})

test_that("function: project_structure can set and query options", {
  yspm::project_structure("test" = "value")
  expect_equal(yspm::project_structure("test"), "value")
  # the value remains in the environment after the test
  # we need to remove it again.
  # ls.str(.yspm.env)
  # rm("test", envir = )
})
