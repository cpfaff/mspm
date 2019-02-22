context("Display information about an enabled project")

test_that("function: enabled_project is defined ", {
  expect_false(identical(find("compile_project_name"), character(0)))
})
