# description
#
# the package supports creating a predefined folder structure. It crates the
# structure by default in the current working directory. It reuires the first
# name and the last name of the author of the project which will be used for
# naming the project folder or a full path. The full path can also serve as a
# flexible alternative for naming the project.

# setup
require(fs)
require(lubridate)

# tests
context("Create project")

test_that("function: create_project is defined ", {
  expect_false(identical(find('create_project'), character(0)))
})

test_that("function: create_project accepts required parameters", {
  expect_true(all(names(formals("create_project")) %in% c("root_folder", "first_name", "last_name", "full_path")))
})

test_that("function: create_project: creates valid folder structure", {
  test_project_folder = create_new_test_project()

  expect_true(dir_exists(test_project_folder))

  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_primary_data"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_interim_data"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_cleaned_data"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_figure_external"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_figure_scripted"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_metadata_dataset"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_metadata_package"))))

  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_metadata_checkpoint"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_metadata_author"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_metadata_license"))))

  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_report_presentation"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_report_publication"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_report_qualification"))))
  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_source_function"))))

  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_packages"))))

  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_source_library"))))

  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_library_main"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_library_import_data"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_library_clean_data"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_library_transform_data"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_library_visualise_data"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_library_model_data"))))

  expect_true(dir_exists(path(test_project_folder, mspm::handle_options("folder_source_workflow"))))

  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_workflow_main"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_workflow_scratchpad"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_workflow_import_data"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_workflow_clean_data"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_workflow_transform_data"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_workflow_visualise_data"))))
  expect_true(file_exists(path(test_project_folder, mspm::handle_options("file_workflow_model_data"))))

  dir_delete(test_project_folder)
})

test_that("function: create_project throws an error when the folder already exists", {
  test_project_folder = create_new_test_project()
  expect_true(dir.exists(test_project_folder))
  expect_error(suppressWarnings(create_project(test_project_folder)))
  dir_delete(test_project_folder)
})

test_that("function: create_project is writing a valid date for checkpoint", {
  test_project_folder = create_new_test_project()
  package_checkpoint = read_dcf_to_list(path(test_project_folder, mspm::handle_options("file_metadata_checkpoint")))
  expect_true(is.Date(ymd(package_checkpoint)))
})

test_that("function: create_project is writing creator of the project as metadata", {
  test_project_folder = create_new_test_project()
  package_author = read_dcf_to_list(path(test_project_folder, "project/metadata/package/author", ext = "dcf"))
  expect_true(is.list((package_author)))
})



