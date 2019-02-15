#' Create a new project
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
#' @importFrom stringr str_detect str_to_lower str_replace_all
#'
#' @export create_project
create_project <- function(root_folder = getwd(), first_name, last_name, full_path = NULL) {
  if(!is.null(full_path)){
    project_path = full_path
  } else {
    project_path = path(root_folder, compile_project_name(current_date = Sys.Date(), first_name = first_name, last_name = last_name))
  }

  big_message("Creating your project")
  small_message("Tasks")

  message("")
  message(paste("Create directories:"))
  message("")
  message(paste("* in:", project_path))
  message("---")

  if(is_dir(path(project_path, "project"))){
    stop("The function create_project: cannot create a project inside an existing one.
         Please Select another project folder. If you want to work on the project
         then execute the function enable_project(<project_path>)")
  }

  dir_create(path(project_path, mspm::handle_options("folder_primary_data")))
  dir_create(path(project_path, mspm::handle_options("folder_interim_data")))
  dir_create(path(project_path, mspm::handle_options("folder_cleaned_data")))
  dir_create(path(project_path, mspm::handle_options("folder_figure_external")))
  dir_create(path(project_path, mspm::handle_options("folder_figure_scripted")))
  dir_create(path(project_path, mspm::handle_options("folder_metadata_dataset")))
  dir_create(path(project_path, mspm::handle_options("folder_metadata_package")))
  dir_create(path(project_path, mspm::handle_options("folder_report_presentation")))
  dir_create(path(project_path, mspm::handle_options("folder_report_publication")))
  dir_create(path(project_path, mspm::handle_options("folder_report_qualification")))
  dir_create(path(project_path, mspm::handle_options("folder_source_function")))
  dir_create(path(project_path, mspm::handle_options("folder_source_library")))
  dir_create(path(project_path, mspm::handle_options("folder_source_workflow")))

  message("")
  message(paste("Create files:"))
  message("")
  message(paste("* in:", project_path))
  message("---")

  file_create(path(project_path, mspm::handle_options("file_packages")))
  file_create(path(project_path, mspm::handle_options("file_metadata_checkpoint")))
  file_create(path(project_path, mspm::handle_options("file_metadata_author")))
  file_create(path(project_path, mspm::handle_options("file_metadata_license")))
  file_create(path(project_path, mspm::handle_options("file_library_main")))
  file_create(path(project_path, mspm::handle_options("file_library_import_data")))
  file_create(path(project_path, mspm::handle_options("file_library_clean_data")))
  file_create(path(project_path, mspm::handle_options("file_library_transform_data")))
  file_create(path(project_path, mspm::handle_options("file_library_visualise_data")))
  file_create(path(project_path, mspm::handle_options("file_library_model_data")))
  file_create(path(project_path, mspm::handle_options("file_workflow_main")))
  file_create(path(project_path, mspm::handle_options("file_workflow_scratchpad")))
  file_create(path(project_path, mspm::handle_options("file_workflow_import_data")))
  file_create(path(project_path, mspm::handle_options("file_workflow_clean_data")))
  file_create(path(project_path, mspm::handle_options("file_workflow_transform_data")))
  file_create(path(project_path, mspm::handle_options("file_workflow_visualise_data")))
  file_create(path(project_path, mspm::handle_options("file_workflow_model_data")))

  system_date_for_checkpoint = list(checkpoint = Sys.Date())
  write_list_to_dcf(system_date_for_checkpoint, path(project_path, mspm::handle_options("file_metadata_checkpoint")))

  if(!is.null(full_path)){
    # we do not yet know how to handle path only in term of author metadata
  } else {
    author_full_name = list(author_name = paste(first_name, last_name))
    write_list_to_dcf(author_full_name, path(project_path, mspm::handle_options("file_metadata_author")))
  }

  message("")
  message("Done:")
  message("")
  message("You can use the fuction enable_project() to initialize it for usage.")
  message("--------------------------")
}
