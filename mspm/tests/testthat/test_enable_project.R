context("Enable project")

test_that("function: enable_project is defined ", {
  expect_false(identical(find('enable_project'), character(0)))
})

test_that("function: enable_project accepts required parameters", {
  expect_true(all(names(formals("enable_project")) %in% c("root_folder", "first_name", "last_name", "full_path")))
})

test_that("function: enable_project throws an error when the folder does not exist", {
    folder_name = path("/tmp",random_string())
    expect_error(enable_project(folder_name))
})

# functionality
test_that("function: enable_project throws an error when the folder contains no project", {
    wd_before_test = getwd()
    folder_name = path("/tmp",random_string())
    dir_create(folder_name)
    expect_error(enable_project(full_path = folder_name))
    dir_delete(folder_name)
    setwd(wd_before_test)
})

test_that("function: enable_project sets the working directory to the project", {
    wd_before_test = getwd()
    folder_name = create_new_test_project()
    enable_project(full_path = folder_name)
    wd_after_enabling_project = getwd()
    expect_equal(path(wd_after_enabling_project), path(folder_name))
    dir_delete(folder_name)
    setwd(wd_before_test)
})

test_that("function: enable_project sets the enabled_project_path in handle_options", {
    wd_before_test = getwd()
    folder_name = create_new_test_project()
    enable_project(full_path = folder_name)
    wd_after_enabling_project = getwd()
    expect_equal(path(wd_after_enabling_project), path(mspm::handle_options("enabled_project_path")))
    dir_delete(folder_name)
    setwd(wd_before_test)
})

test_that("function: enable_project sets the enabled_project_checkpoint in handle_options", {
    wd_before_test = getwd()
    folder_name = create_new_test_project()
    enable_project(full_path = folder_name)
    project_creation_date_from_file = as.character(read_dcf_to_list(path(mspm::handle_options("file_metadata_checkpoint"))))
    project_creation_date_from_options = as.character(mspm::handle_options("enabled_project_checkpoint"))
    expect_equal(project_creation_date_from_file, project_creation_date_from_options)
    dir_delete(folder_name)
    setwd(wd_before_test)
})
