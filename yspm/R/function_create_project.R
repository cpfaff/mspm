#' Create a new project
#'
#' A function that creates a new project. A project consists of a predefined
#' folder structure. The structure separates into folder like data, metadata,
#' source and reporting to help better organize your new project.
#'
#' @param root_path The path to theroot folder designates the location in the
#'        filesystem where the project will bestored.
#' @param project_name The project name is the name of the folder the predefined
#'        structure is created in. This parameter allows you to freely name the
#'        project. You can use it together with the compile_project_name
#'        function to generate streamlined project names.
#' @param project_path Instead of using the root_folder and project_name arguments
#'        the full path allows to specify the the path to the folder in which which
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
#' @importFrom fs path dir_create file_create
#' @importFrom devtools install_github
#' @importFrom withr with_libpaths
#'
#' @export create_project

create_project <- function(root_path = getwd(), project_name = NULL, project_path = NULL) {
  normalized_root_path <- suppressWarnings(normalizePath(path(root_path)))

  if (is.null(project_name)) {
    stop("create_project: requires the parameter project name")
  }
  if (!is.character(project_name)) {
    stop("create_project: parameter project name needs to be provided as character")
  }
  if (is.null(project_path)) {
    project_path <- path(normalized_root_path, project_name)
  } else {
    project_path <- suppressWarnings(normalizePath(path(project_path)))
  }
  if (is_dir(path(project_path, "project"))) {
    stop("The function create_project: cannot create a project inside an existing one.
         Please Select another project folder. If you want to work on the project
         then execute the function enable_project(<project_path>)")
  }

  big_message("Creating your project")
  small_message("Tasks")

  message("")
  message(paste("Create directories:"))
  message("")
  message(paste("* in:", project_path))
  message("---")


  dir_create(path(project_path, yspm::project_structure("folder_primary_data")))
  dir_create(path(project_path, yspm::project_structure("folder_interim_data")))
  dir_create(path(project_path, yspm::project_structure("folder_cleaned_data")))
  dir_create(path(project_path, yspm::project_structure("folder_figure_external")))
  dir_create(path(project_path, yspm::project_structure("folder_figure_scripted")))
  dir_create(path(project_path, yspm::project_structure("folder_metadata_dataset")))
  dir_create(path(project_path, yspm::project_structure("folder_metadata_package")))
  dir_create(path(project_path, yspm::project_structure("folder_report_presentation")))
  dir_create(path(project_path, yspm::project_structure("folder_report_publication")))
  dir_create(path(project_path, yspm::project_structure("folder_report_qualification")))
  dir_create(path(project_path, yspm::project_structure("folder_source_library")))
  dir_create(path(project_path, yspm::project_structure("folder_source_workflow")))

  message("")
  message(paste("Create files:"))
  message("")
  message(paste("* in:", project_path))
  message("---")

  file_create(path(project_path, yspm::project_structure("file_library_packages")))
  file_create(path(project_path, yspm::project_structure("file_metadata_checkpoint")))
  file_create(path(project_path, yspm::project_structure("file_metadata_author")))
  file_create(path(project_path, yspm::project_structure("file_metadata_license")))
  file_create(path(project_path, yspm::project_structure("file_library_main")))
  file_create(path(project_path, yspm::project_structure("file_library_import_data")))
  file_create(path(project_path, yspm::project_structure("file_library_clean_data")))
  file_create(path(project_path, yspm::project_structure("file_library_transform_data")))
  file_create(path(project_path, yspm::project_structure("file_library_visualise_data")))
  file_create(path(project_path, yspm::project_structure("file_library_model_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_main")))
  file_create(path(project_path, yspm::project_structure("file_workflow_import_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_clean_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_transform_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_visualise_data")))
  file_create(path(project_path, yspm::project_structure("file_workflow_model_data")))

  # constructing default file content
  construct_file_packages(project_path = project_path)

  # setting system checkpoint date into checkpoint file
  system_date_for_checkpoint <- list(checkpoint = Sys.Date())
  write_list_to_dcf(system_date_for_checkpoint, path(project_path, yspm::project_structure("file_metadata_checkpoint")))

  message("")
  message(paste("Install packages:"))
  message("")
  message(paste("* in:", project_path))
  message("---")

  wd_before <- getwd()
  repo_before <- getOption("repos")
  lib_paths_before <- suppressWarnings(normalizePath(unique(.libPaths())))

  setwd(project_path)

  # if we run in rstudio to prevent the dialogue
  if (Sys.getenv("RSTUDIO") == "1") {
    loaded_packages <- names(sessionInfo()$otherPkgs)
    exclude_packages <- c("yspm")
    detachable_packages <- setdiff(loaded_packages, exclude_packages)
    quiet(suppressWarnings(lapply(detachable_packages, function(package) {
      try(detach(paste0("package:", package), character.only = TRUE, unload = TRUE, force = TRUE), silent = T)
    })))
  }

  # set up the new local package library and repository url
  checkpoint::checkpoint(
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
    devtools::install_github("cpfaff/yspm", subdir = "yspm")

    # again working around windows and rstudio quirks
    if (Sys.getenv("RSTUDIO") == "1") {
      exclude_packages <- c("yspm", "checkpoint")
      installed_packages <- unname(installed.packages()[, "Package"])
      updatable_packages <- setdiff(installed_packages, exclude_packages)
      update.packages(updatable_packages, dependencies = F, checkBuilt = T, ask = F)
    }
  },
  error = function(cond) {
    .libPaths(lib_paths_before)
    setwd(wd_before)
    options(repos = repo_before)

    message("")
    message("Oh no something went wrong:")
    message("")
    message("--------------------------")
  },
  finally = {
    .libPaths(lib_paths_before)
    setwd(wd_before)

    options(repos = repo_before)

    message("")
    message("Done:")
    message("")
    message("You can use the fuction enable_project() to initialize it for usage.")
    message("--------------------------")
  }
  )
}
