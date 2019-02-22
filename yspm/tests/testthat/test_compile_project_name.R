context("Compile project name")

test_that("function: compile_project_name is defined ", {
  expect_false(identical(find('compile_project_name'), character(0)))
})

test_that("function: create_project accepts required parameters", {
  expect_true(all(names(formals("compile_project_name")) %in% c("project_date", "first_name", "last_name", "project_category")))
})
