#' Create a new project
#'
#' A function that creates a new project. A project consists of a predefined
#' folder structure. The structure separates into folder like data, metadata,
#' source and reporting to help better organize your new project.
#'
#' @param root_path The path to the root folder designates the location in the
#'        file system where the project will be stored.
#' @param project_name The project name is the name of the folder the predefined
#'        structure is created in. This parameter allows you to freely name the
#'        project. You can use it together with the compile_project_name
#'        function to generate streamlined project names. It allows you to pass
#'        in a constructor function. It collects all parameters names and their
#'        values to write them as a key value pair into a metadata file called
#'        project.dc in the metadata folder of the project. The package comes
#'        with a default constructor called compile_project_name()
#' @param project_path Instead of using the root_folder and project_name arguments
#'        the full path allows to specify the path to the folder in which which
#'        the predefined project folder structure will be created in.
#'
#' @examples
#' \dontrun{
#' create_project(
#'   root_path = getwd(),
#'   project_name = compile_project_name(
#'     first_name = "Max",
#'     last_name = "Mustermann",
#'     project_category = "Phd"
#'   )
#' )
#' }
#' 
#' @return This function does not return anything; It is called for its side effect
#'
#' @importFrom fs path dir_create file_create
#' @importFrom devtools install_github
#' @importFrom remotes update_packages
#' @importFrom withr with_libpaths
#'
#' @export create_project

create_project <- function(root_path = getwd(),
                           project_name = NULL,
                           project_path = NULL) {

  # get the name of the current function
  the_function <- match.call()[[1]]

  # normalize the root_path
  normalized_root_path <- suppressWarnings(normalizePath(path(root_path)))

  # check if the project name parameter is used
  if (is.null(project_name)) {
    stop("create_project: requires the parameter project name")
  }

  # if project name contains a function call evaluate it
  if (is.call(project_name)) {
    eval(project_name)
  }

  # test if we get back a string from the project name function
  if (is.call(project_name)) {
    if (!is.character(eval(project_name))) {
      stop("Your project name constructor function does not return a string!")
    }
  }

  # check if project name is a single string
  if (length(eval(project_name)) > 1) {
    stop(paste("Your project name constructor function does not return a single string! Instead we have", length(eval(project_name))))
  }

  # if we get a constructor passed into the project name then deconstruct the given parameters
  # as this allows to reuse the information as metadata later.
  convert_call_to_list <- function(project_name_value) {
    if (is.call(project_name_value)) as.list(project_name_value) else project_name_value
  }

  first_pass <- as.list(match.call())
  second_pass <- lapply(first_pass, convert_call_to_list)
  setNames(second_pass, names(first_pass))

  # if there is calls in the parameters they need evaluation as otherwise
  # the function calls end up in the metadata instead of the actual evaluated
  # content e.g. a system date.
  if (is.list(second_pass$project_name)) {
    metadata_from_parameters <- second_pass$project_name[-1]
    metadata_from_parameters <- lapply(metadata_from_parameters, function(parameter) {
      if (is.call(parameter)) {
        eval(parameter)
      } else {
        parameter
      }
    })
  }

  if (is.null(project_path)) {
    project_path <- path(normalized_root_path, project_name)
  } else {
    project_path <- suppressWarnings(normalizePath(path(project_path)))
  }

  if (is_dir(path(project_path, "project"))) {
    stop(paste0(the_function, ": cannot create a project inside an existing one.
         Please Select another project folder. If you want to work on the project
         then execute the function enable_project(<project_path>)"))
  }

  big_message("Creating your project")
  small_message("Tasks")

  message("")
  message(paste("Create directories:"))
  message("")
  message(paste("* in:", project_path))
  message("---")
  message("")

  message(paste("*", yspm::project_structure("folder_primary_data")))
  dir_create(path(project_path, yspm::project_structure("folder_primary_data")))

  message(paste("*", yspm::project_structure("folder_interim_data")))
  dir_create(path(project_path, yspm::project_structure("folder_interim_data")))

  message(paste("*", yspm::project_structure("folder_cleaned_data")))
  dir_create(path(project_path, yspm::project_structure("folder_cleaned_data")))

  message(paste("*", yspm::project_structure("folder_figure_external")))
  dir_create(path(project_path, yspm::project_structure("folder_figure_external")))

  message(paste("*", yspm::project_structure("folder_figure_scripted")))
  dir_create(path(project_path, yspm::project_structure("folder_figure_scripted")))

  message(paste("*", yspm::project_structure("folder_metadata_dataset")))
  dir_create(path(project_path, yspm::project_structure("folder_metadata_data")))

  message(paste("*", yspm::project_structure("folder_metadata_project")))
  dir_create(path(project_path, yspm::project_structure("folder_metadata_project")))

  message(paste("*", yspm::project_structure("folder_report_presentation")))
  dir_create(path(project_path, yspm::project_structure("folder_report_presentation")))

  message(paste("*", yspm::project_structure("folder_report_publication")))
  dir_create(path(project_path, yspm::project_structure("folder_report_publication")))

  message(paste("*", yspm::project_structure("folder_report_qualification")))
  dir_create(path(project_path, yspm::project_structure("folder_report_qualification")))

  message(paste("*", yspm::project_structure("folder_source_library")))
  dir_create(path(project_path, yspm::project_structure("folder_source_library")))

  message(paste("*", yspm::project_structure("folder_source_workflow")))
  dir_create(path(project_path, yspm::project_structure("folder_source_workflow")))

  message("")
  message(paste("Create files:"))
  message("")
  message(paste("* in:", project_path))
  message("---")
  message("")

  message(paste("*", yspm::project_structure("file_metadata_project")))
  file_create(path(project_path, yspm::project_structure("file_metadata_project")))

  message(paste("*", yspm::project_structure("file_library_main")))
  file_create(path(project_path, yspm::project_structure("file_library_main")))

  message(paste("*", yspm::project_structure("file_library_import_data")))
  file_create(path(project_path, yspm::project_structure("file_library_import_data")))

  message(paste("*", yspm::project_structure("file_library_clean_data")))
  file_create(path(project_path, yspm::project_structure("file_library_clean_data")))

  message(paste("*", yspm::project_structure("file_library_transform_data")))
  file_create(path(project_path, yspm::project_structure("file_library_transform_data")))

  message(paste("*", yspm::project_structure("file_library_visualise_data")))
  file_create(path(project_path, yspm::project_structure("file_library_visualise_data")))

  message(paste("*", yspm::project_structure("file_library_model_data")))
  file_create(path(project_path, yspm::project_structure("file_library_model_data")))

  message(paste("*", yspm::project_structure("file_workflow_packages")))
  file_create(path(project_path, yspm::project_structure("file_workflow_packages")))

  message(paste("*", yspm::project_structure("file_workflow_main")))
  file_create(path(project_path, yspm::project_structure("file_workflow_main")))

  message(paste("*", yspm::project_structure("file_workflow_import_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_import_data")))

  message(paste("*", yspm::project_structure("file_workflow_clean_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_clean_data")))

  message(paste("*", yspm::project_structure("file_workflow_transform_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_transform_data")))

  message(paste("*", yspm::project_structure("file_workflow_visualise_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_visualise_data")))

  message(paste("*", yspm::project_structure("file_workflow_model_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_model_data")))

  # constructing default file content
  construct_file_packages(project_path = project_path)

  message("")
  message(paste("Write metadata:"))
  message("")
  message(paste("* in:", project_path))
  message("---")
  message("")

  message(paste("*", yspm::project_structure("file_metadata_checkpoint")))
  # the checkpoint is modifyable however the creation date of the project is set
  # automatically to the sytem date we create the project
  if (exists("metadata_from_parameters")) {
    if ("project_date" %in% names(metadata_from_parameters)) {
      checkpoint <- list(checkpoint = metadata_from_parameters$project_date)
    } else {
      checkpoint <- list(checkpoint = Sys.Date())
    }
  } else {
    checkpoint <- list(checkpoint = Sys.Date())
  }


  write_project_metadata(data.frame(checkpoint = checkpoint), file_path = path(project_path, yspm::project_structure("file_metadata_project")))

  if (exists("metadata_from_parameters")) {
    message(paste("*", yspm::project_structure("file_metadata_project")))
    current_project_metadata <- read_project_metadata(file_path = path(project_path, yspm::project_structure("file_metadata_project")))
    new_project_metadata <- set_project_metadata(old_metadata = current_project_metadata, new_metadata = metadata_from_parameters)
    write_project_metadata(metadata = new_project_metadata, file_path = path(project_path, yspm::project_structure("file_metadata_project")))
  }

  message(paste("*", yspm::project_structure("file_metadata_license")))
  license_and_system <- list(license = yspm::yspm_options("project_license"), sytstem = get_os())
  current_project_metadata <- read_project_metadata(file_path = path(project_path, yspm::project_structure("file_metadata_project")))
  new_project_metadata <- set_project_metadata(old_metadata = current_project_metadata, new_metadata = license_and_system)
  write_project_metadata(metadata = new_project_metadata, file_path = path(project_path, yspm::project_structure("file_metadata_project")))

  stop("HERE")

  message("")
  message(paste("Install packages:"))
  message("")
  message(paste("* in:", project_path))
  message("---")
  wd_before <- getwd()
  repo_before <- getOption("repos")
  lib_paths_before <- suppressWarnings(normalizePath(unique(.libPaths())))

  setwd(project_path)

  # if we run in rstudio to prevent the dialogue detach all packages that are not required
  if (Sys.getenv("RSTUDIO") == "1") {
    loaded_packages <- names(sessionInfo()$otherPkgs)
    exclude_packages <- c("yspm")
    detachable_packages <- setdiff(loaded_packages, exclude_packages)
    quiet(suppressWarnings(lapply(detachable_packages, function(package) {
      try(detach(paste0("package:", package), character.only = TRUE, unload = TRUE, force = TRUE), silent = T)
    })))
  }

  # set up the new local package library and repository url
  yspmcheckpoint::checkpoint(
    authorizeFileSystemUse = F,
    forceSetMranMirror = T,
    installPackagesWithDependency = T,
    snapshotDate = as.character(Sys.Date()),
    forceCreateFolders = T,
    scanForPackages = F,
    verbose = F,
    checkpointLocation = suppressWarnings(normalizePath(fs::path(project_path, yspm::project_structure("folder_source_library")))),
    project = project_path
  )

  tryCatch({
    devtools::install_github("cpfaff/yspm", subdir = "yspm", dependencies = TRUE)
    non_writable_libraries <- as.numeric(which(file.access(.libPaths(), mode = 2) == -1))
    update.packages(ask = F, checkBuilt = T, instlib = .libPaths()[-non_writable_libraries])
  },
  error = function(cond) {
    .libPaths(lib_paths_before)
    setwd(wd_before)
    options(repos = repo_before)

    message("")
    message("Some problems occurred during the installation and update of packages in the new environment.")
    message("")
  },
  finally = {
    .libPaths(lib_paths_before)
    setwd(wd_before)
    options(repos = repo_before)

    message("")
    message("Done:")
    message("")
    message("You can use the function enable_project() to initialize it for usage.")
    message("--------------------------")
  }
  )
}
