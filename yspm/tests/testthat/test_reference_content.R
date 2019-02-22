context("Project content reference")

test_that("function: project_content is defined ", {
  expect_false(identical(find('project_content'), character(0)))
})

test_that("function: project_content accepts required parameters", {
  expect_true(all(names(formals("enable_project")) %in% c("path")))
})

