context("Enable project")

test_that("function: enable_project is defined ", {
  expect_false(identical(find("enable_project"), character(0)))
})

test_that("function: enable_project accepts required parameters", {
  expect_true(all(names(formals("enable_project")) %in% c("root_path", "project_name", "project_path")))
})

test_that("function: enable_project throws an error when the folder does not exist", {
  root_path <- path("/tmp")
  project_name <- path(random_string())
  expect_error(enable_project(root_path = root_path, project_name = project_name))
})

# functionality
test_that("function: enable_project throws an error when the folder contains no project", {
  wd_before_test <- getwd()
  root_path <- path("/tmp")
  project_name <- path(random_string())
  dir_create(path(root_path, project_name))
  expect_error(enable_project(root_path = root_path, project_name = project_name))
  dir_delete(path(root_path, project_name))
  setwd(wd_before_test)
})

if (TRUE) skip("These test take way to long!")

test_that("function: enable_project sets the working directory to the project", {
  wd_before_test <- getwd()
  repo_before_test <- getOption("repos")
  create_project(root_path = "/tmp", compile_project_name(first_name = "first_name", last_name = "last_name"))
  enable_project(root_path = "/tmp", compile_project_name(first_name = "first_name", last_name = "last_name"))
  wd_after_enabling_project <- getwd()
  expect_equal(path(wd_after_enabling_project), path("/tmp", paste(c(as.character(Sys.Date()), "first_name_last_name"), collapse = "_")))
  dir_delete(path("/tmp", paste(c(as.character(Sys.Date()), "first_name_last_name"), collapse = "_")))
  setwd(wd_before_test)
  options(repos = repo_before_test)
})

test_that("function: enable_project sets the project_path in enabled_project", {
  wd_before_test <- getwd()
  repo_before_test <- getOption("repos")
  create_project(root_path = "/tmp", compile_project_name(first_name = "first_name", last_name = "last_name"))
  enable_project(root_path = "/tmp", compile_project_name(first_name = "first_name", last_name = "last_name"))
  wd_after_enabling_project <- getwd()
  options(repos = repo_before_test)
  dir_delete(path("/tmp", paste(c(as.character(Sys.Date()), "first_name_last_name"), collapse = "_")))
  expect_equal(path(wd_after_enabling_project), path(yspm::enabled_project("project_path")))
  setwd(wd_before_test)
})

test_that("function: enable_project sets the project_checkpoint in enabled_project", {
  wd_before_test <- getwd()
  repo_before_test <- getOption("repos")
  create_project(root_path = "/tmp", compile_project_name(first_name = "first_name", last_name = "last_name"))
  enable_project(root_path = "/tmp", compile_project_name(first_name = "first_name", last_name = "last_name"))
  options(repos = repo_before_test)
  project_creation_date_from_file <- as.character(read_dcf_to_list(path(yspm::project_structure("file_metadata_checkpoint"))))
  project_creation_date_from_options <- as.character(yspm::enabled_project("project_checkpoint"))
  dir_delete(path("/tmp", paste(c(as.character(Sys.Date()), "first_name_last_name"), collapse = "_")))
  expect_equal(project_creation_date_from_file, project_creation_date_from_options)
  setwd(wd_before_test)
})
