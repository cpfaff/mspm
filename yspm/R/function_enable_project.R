#' Enable an existing project
#'
#' A function that enables an existing project.
#'
#' @param root_folder The root folder designates the path in the filesystem
#'        where the project is stored.
#' @param project_name The project name is the name of the folder the predefined
#'        project structure has been created in. This parameter allows you to freely
#'        name the project. You can use it together with the compile_project_name
#'        function to get the same streamlined project names as during the project
#'        creation.
#' @param project_path Instead of using the root_folder and project_name arguments
#'        the full path to the project folder can be specifified here.
#'
#' @examples
#' \dontrun{
#' enable_project(
#'   root_folder = getwd(),
#'   project_name = compile_project_name(
#'     first_name = "Max",
#'     last_name = "Mustermann",
#'     project_category = "Phd"
#'   )
#' )
#'
#' enable_project(
#'   root_folder = "~/",
#'   project_name = "my_phd_project"
#' )
#' }
#'
#' @import checkpoint
#' @importFrom fs path file_create is_file dir_create dir_delete is_dir dir_exists file_exists
#' @importFrom magrittr "%>%"
#' @importFrom tibble as_tibble
#' @importFrom readr write_csv
#' @importFrom stringr str_extract_all str_split
#' @importFrom magrittr use_series
#'
#' @export enable_project

enable_project <- function(root_folder = getwd(), project_name = NULL, project_path = NULL) {
  if (is.null(project_path)) {
    project_path <- path(root_folder, project_name)
  }

  # does the project_path exist at all
  if (!is_dir(path(project_path))) {
    stop(paste(
      "enable_project failed: The project_path you provide does not exist.
                 Please check the spelling.",
      project_path
    ))
  }

  big_message("Enable project")
  small_message("Tasks")

  if (!all(
    dir_exists(path(project_path, yspm::project_structure("folder_primary_data"))),
    dir_exists(path(project_path, yspm::project_structure("folder_interim_data"))),
    dir_exists(path(project_path, yspm::project_structure("folder_cleaned_data"))),
    dir_exists(path(project_path, yspm::project_structure("folder_figure_external"))),
    dir_exists(path(project_path, yspm::project_structure("folder_figure_scripted"))),
    dir_exists(path(project_path, yspm::project_structure("folder_metadata_dataset"))),
    dir_exists(path(project_path, yspm::project_structure("folder_metadata_package"))),
    file_exists(path(project_path, yspm::project_structure("file_metadata_checkpoint"))),
    file_exists(path(project_path, yspm::project_structure("file_metadata_author"))),
    file_exists(path(project_path, yspm::project_structure("file_metadata_license"))),
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

  yspm::enabled_project("project_path" = project_path)

  project_creation_date <-
    as.character(read_dcf_to_list(path(project_path, yspm::project_structure("file_metadata_checkpoint"))))

  message("")
  message(paste("Set checkpoint:"))
  message("")
  message(paste("* to:", project_creation_date))
  message("---")

  checkpoint(
    authorizeFileSystemUse = F,
    forceSetMranMirror = T,
    installPackagesWithDependency = T,
    snapshotDate = project_creation_date,
    scanForPackages = F,
    verbose = F,
    checkpointLocation = path(project_path, yspm::project_structure("folder_source_library")),
    project = project_path
  )

  yspm::enabled_project("project_checkpoint" = project_creation_date)

  message("")
  message(paste("Done"))
  message("--------------------------")
}
