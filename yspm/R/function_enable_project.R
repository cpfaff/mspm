#' Enable an existing project
#'
#' A function that enables an existing project.
#'
#' @param root_path The root folder designates the path in the filesystem
#'        where the project is stored.
#' @param project_name The project name is the name of the folder the predefined
#'        project structure has been created in. This parameter allows you to freely
#'        name the project. You can use it together with the compile_project_name
#'        function to get the same streamlined project names as during the project
#'        creation.
#' @param project_path Instead of using the root_path and project_name arguments
#'        the full path to the project folder can be specifified here.
#'
#' @examples
#' \dontrun{
#' enable_project(
#'   root_path = getwd(),
#'   project_name = compile_project_name(
#'     first_name = "Max",
#'     last_name = "Mustermann",
#'     project_category = "Phd"
#'   )
#' )
#' 
#' enable_project(
#'   root_path = "~/",
#'   project_name = "my_phd_project"
#' )
#' }
#' 
#' @importFrom fs path file_create is_file dir_create dir_delete is_dir dir_exists file_exists
#' @export enable_project

enable_project <- function(root_path = getwd(), project_name = NULL, project_path = NULL) {
  normalized_root_path <- suppressWarnings(normalizePath(path(root_path)))

  if (is.null(project_path)) {
    project_path <- path(normalized_root_path, project_name)
  } else {
    project_path <- suppressWarnings(normalizePath(path(project_path)))
  }

  if (!is_dir(path(project_path))) {
    stop(paste(
      "enable_project failed: The project_path you provide does not exist.
                 Please check the spelling.",
      project_path
    ))
  }

  big_message("Enable project")
  small_message("Tasks")

  # that might be a to restrictive test as the structure might need to be a little
  # bit more flexible to adapt by the user. It should be a suggestion so maybe we
  # rather check for the first level of folder under the project folder only.
  if (!all(
    dir_exists(path(project_path, yspm::project_structure("folder_primary_data"))),
    dir_exists(path(project_path, yspm::project_structure("folder_interim_data"))),
    dir_exists(path(project_path, yspm::project_structure("folder_cleaned_data"))),
    dir_exists(path(project_path, yspm::project_structure("folder_figure_external"))),
    dir_exists(path(project_path, yspm::project_structure("folder_figure_scripted"))),
    dir_exists(path(project_path, yspm::project_structure("folder_metadata_dataset"))),
    dir_exists(path(project_path, yspm::project_structure("folder_metadata_package"))),
    file_exists(path(project_path, yspm::project_structure("file_metadata_project"))),
    dir_exists(path(project_path, yspm::project_structure("folder_report_presentation"))),
    dir_exists(path(project_path, yspm::project_structure("folder_report_publication"))),
    dir_exists(path(project_path, yspm::project_structure("folder_report_qualification"))),
    file_exists(path(project_path, yspm::project_structure("file_library_packages"))),
    dir_exists(path(project_path, yspm::project_structure("folder_source_library"))),
    file_exists(path(project_path, yspm::project_structure("file_library_main"))),
    file_exists(path(project_path, yspm::project_structure("file_library_import_data"))),
    file_exists(path(project_path, yspm::project_structure("file_library_clean_data"))),
    file_exists(path(project_path, yspm::project_structure("file_library_transform_data"))),
    file_exists(path(project_path, yspm::project_structure("file_library_visualise_data"))),
    file_exists(path(project_path, yspm::project_structure("file_library_model_data"))),
    dir_exists(path(project_path, yspm::project_structure("folder_source_workflow"))),
    file_exists(path(project_path, yspm::project_structure("file_workflow_main"))),
    file_exists(path(project_path, yspm::project_structure("file_workflow_import_data"))),
    file_exists(path(project_path, yspm::project_structure("file_workflow_clean_data"))),
    file_exists(path(project_path, yspm::project_structure("file_workflow_transform_data"))),
    file_exists(path(project_path, yspm::project_structure("file_workflow_visualise_data"))),
    file_exists(path(project_path, yspm::project_structure("file_workflow_model_data")))
  )) {
    stop(paste("enable_project failed: The project_path seems not to contain a valid project.
                 Choose a different location, or check the spelling."))
  }

  message("")
  message(paste("Set working diretory:"))
  message("")
  message(paste("* to:", project_path))
  message("---")
  message("")

  wd_before <- getwd()
  repo_before <- getOption("repos")
  lib_paths_before <- suppressWarnings(normalizePath(unique(.libPaths())))

  setwd(project_path)

  project_metadata <-
    read_project_metadata(file_path = fs::path(project_path, yspm::project_structure("file_metadata_project")))

  package_date <-
    get_project_metadata(project_metadata, "checkpoint")

  message("")
  message(paste("Set checkpoint:"))
  message("")
  message(paste("* to:", package_date))
  message("---")
  message("")

  # if we run in rstudio to prevent the dialogue
  if (Sys.getenv("RSTUDIO") == "1") {
    loaded_packages <- names(sessionInfo()$otherPkgs)
    detachable_packages <- loaded_packages
    quiet(suppressWarnings(lapply(detachable_packages, function(package) {
      try(detach(paste0("package:", package), character.only = TRUE, unload = TRUE, force = TRUE), silent = T)
    })))
  }

  yspmcheckpoint::checkpoint(
    authorizeFileSystemUse = F,
    forceSetMranMirror = T,
    installPackagesWithDependency = T,
    snapshotDate = package_date,
    scanForPackages = F,
    verbose = F,
    checkpointLocation = normalizePath(fs::path(project_path, yspm::project_structure("folder_source_library"))),
    project = project_path
  )

  .libPaths(c(.libPaths(), lib_paths_before))

  require(yspm)
  yspm::enabled_project("project_checkpoint" = package_date)
  yspm::enabled_project("project_path" = project_path)

  install_requirements()

  message("")
  message(paste("Done"))
  message("--------------------------")
}
