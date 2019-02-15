#' Enable an existing project
#'
#' @param root_folder Allows to change the location in which the function
#'        creates the new project folder. dateFirst and last name together with
#'        the degree are forming the projct folder name inside the
#'        root_folder (see next params)
#' @param first_name Allows to provide the first name of the creator and
#'        reponsible person for the project.
#'        project (mandatory)
#' @param last_name Allows to provide the last name of the creator and
#'        responsible person for the project.
#'        project (mandatory)
#' @param full_path Allows you to specify the full path to a project root folder.
#'        This also allows to createa a flexible named folder for projects.
#'
#' @import checkpoint
#' @importFrom fs path file_create is_file dir_create dir_delete is_dir
#' @importFrom magrittr "%>%"
#' @importFrom tibble as_tibble
#' @importFrom readr write_csv
#' @importFrom stringr str_extract_all str_split
#' @importFrom magrittr use_series
#'
#' @export enable_project

enable_project <-  function(root_folder = getwd(), first_name, last_name, full_path = NULL) {
    # either use full path or a contruction function to enable a project
    if(!is.null(full_path)){
        project_path = full_path
    } else {
        project_folder_name =
            compile_project_name(current_date = Sys.Date(), first_name = first_name, last_name = last_name)
        project_path =
            path(root_folder, project_folder_name)
    }

    # does the project_path exist at all
    if(!is_dir(path(project_path))){
        stop(paste("enable_project failed: The project_path you provide does not exist.
                   Please check the spelling.",
                   project_path))
    }

    big_message("Enable project")
    small_message("Tasks")

    if(!all(dir_exists(path(project_path, mspm::handle_options("folder_primary_data"))),
            dir_exists(path(project_path, mspm::handle_options("folder_interim_data"))),
            dir_exists(path(project_path, mspm::handle_options("folder_cleaned_data"))),
            dir_exists(path(project_path, mspm::handle_options("folder_figure_external"))),
            dir_exists(path(project_path, mspm::handle_options("folder_figure_scripted"))),
            dir_exists(path(project_path, mspm::handle_options("folder_metadata_dataset"))),
            dir_exists(path(project_path, mspm::handle_options("folder_metadata_package"))),
            file_exists(path(project_path, mspm::handle_options("file_metadata_checkpoint"))),
            file_exists(path(project_path, mspm::handle_options("file_metadata_author"))),
            file_exists(path(project_path, mspm::handle_options("file_metadata_license"))),
            dir_exists(path(project_path, mspm::handle_options("folder_report_presentation"))),
            dir_exists(path(project_path, mspm::handle_options("folder_report_publication"))),
            dir_exists(path(project_path, mspm::handle_options("folder_report_qualification"))),
            dir_exists(path(project_path, mspm::handle_options("folder_source_function"))),
            file_exists(path(project_path, mspm::handle_options("file_packages"))),
            dir_exists(path(project_path, mspm::handle_options("folder_source_library"))),
            file_exists(path(project_path, mspm::handle_options("file_library_main"))),
            file_exists(path(project_path, mspm::handle_options("file_library_import_data"))),
            file_exists(path(project_path, mspm::handle_options("file_library_clean_data"))),
            file_exists(path(project_path, mspm::handle_options("file_library_transform_data"))),
            file_exists(path(project_path, mspm::handle_options("file_library_visualise_data"))),
            file_exists(path(project_path, mspm::handle_options("file_library_model_data"))),
            dir_exists(path(project_path, mspm::handle_options("folder_source_workflow"))),
            file_exists(path(project_path, mspm::handle_options("file_workflow_main"))),
            file_exists(path(project_path, mspm::handle_options("file_workflow_import_data"))),
            file_exists(path(project_path, mspm::handle_options("file_workflow_clean_data"))),
            file_exists(path(project_path, mspm::handle_options("file_workflow_transform_data"))),
            file_exists(path(project_path, mspm::handle_options("file_workflow_visualise_data"))),
            file_exists(path(project_path, mspm::handle_options("file_workflow_model_data"))))){
        stop(paste("enable_project failed: The project_path seems not to contain a valid project.
                   Choose a different location, or check the spelling."))
    }

    message("")
    message(paste("Set working diretory:"))
    message("")
    message(paste("* to:", project_path))
    message("---")

    setwd(project_path)
    mspm::handle_options("enabled_project_path" = project_path)

    project_creation_date =
        as.character(read_dcf_to_list(path(project_path, mspm::handle_options("file_metadata_checkpoint"))))

    message("")
    message(paste("Set checkpoint:"))
    message("")
    message(paste("* to:", project_creation_date))
    message("---")

    checkpoint(authorizeFileSystemUse = F,
               forceSetMranMirror = T,
               installPackagesWithDependency = T,
               snapshotDate = project_creation_date,
               scanForPackages = T,
               verbose = F,
               checkpointLocation = path(project_path, mspm::handle_options("folder_source_library")),
               project = project_path)

    mspm::handle_options("enabled_project_checkpoint" = project_creation_date)

    message("")
    message(paste("Done"))
    message("--------------------------")
}
