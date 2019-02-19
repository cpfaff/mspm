#' Create a new project
#'
#' A function that creates a new project. A project consists of a predefined
#' folder structure. The structure separates into folder like data, metadata,
#' source and reporting to help better organize your new project.
#'
#' @param root_folder The root folder designates the location in the filesystem
#'        where the project will bestored.
#' @param project_name The project name is the name of the folder the predefined
#'        structure is created in. This parameter allows you to freely name the
#'        project. You can use it together with the compile_project_name
#'        function to generate streamlined project names.
#' @param project_path Instead of using the root_folder and project name arguments
#'        the full path to the folder can be specifified in which the project
#'        structure will be created in.
#'
#' @examples
#' \dontrun{
#'  create_project(root_folder = getwd(),
#'                 project_name = compile_project_name(first_name = "Max",
#'                                                     last_name = "Mustermann",
#'                                                     project_category "Phd"))
#' }
#'
#' @importFrom fs path dir_create file_create
#' @importFrom devtools install_github
#'
#' @export create_project

create_project <- function(root_folder = getwd(), project_name = NULL, project_path = NULL) {
  if(is.null(project_name)){
    stop("create_project: requires the parameter project name")
  }
  if(!is.character(project_name)){
    stop("create_project: parameter project name needs to be provided as character")
  }
  if(is.null(project_path)){
    project_path = path(root_folder, project_name)
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

  dir_create(path(project_path, mspm::project_structure("folder_primary_data")))
  dir_create(path(project_path, mspm::project_structure("folder_interim_data")))
  dir_create(path(project_path, mspm::project_structure("folder_cleaned_data")))
  dir_create(path(project_path, mspm::project_structure("folder_figure_external")))
  dir_create(path(project_path, mspm::project_structure("folder_figure_scripted")))
  dir_create(path(project_path, mspm::project_structure("folder_metadata_dataset")))
  dir_create(path(project_path, mspm::project_structure("folder_metadata_package")))
  dir_create(path(project_path, mspm::project_structure("folder_report_presentation")))
  dir_create(path(project_path, mspm::project_structure("folder_report_publication")))
  dir_create(path(project_path, mspm::project_structure("folder_report_qualification")))
  dir_create(path(project_path, mspm::project_structure("folder_source_function")))
  dir_create(path(project_path, mspm::project_structure("folder_source_library")))
  dir_create(path(project_path, mspm::project_structure("folder_source_workflow")))

  # constructs and writesthe packages into the package mangement file

optional_packages = c("readr",
                         "preadxl",
                         "haven",
                         "httr",
                         "rvest",
                         "xml2",
                         "tidyr",
                         "purrr",
                         "dplyr",
                         "forcats",
                         "hms",
                         "lubridate",
                         "stringr",
                         "ggplot2",
                         "broom",
                         "modelr",
                         "RColorBrewer")

mandatory_packages = c("import", # for the package management
                       "devtools", # install from github
                       "drake", # for the workflow functionality
                       "tibble", # for better data frames
                       "magrittr"# for the pipe
                      )

constructed_library_calls =
  lapply(optional_packages,
         function(package){
           paste0("# ", "library(",package, ")")
         }
  )

lapply(constructed_library_calls,
       function(a_recommended_library){
         write(a_recommended_library,
               file = path(project_path, mspm::project_structure("file_packages")),
               append = TRUE)
       }
      )

constructed_library_calls = lapply(mandatory_packages,
                                   function(package){
                                     paste0("library(",package, ")")
                                   }
                                  )

lapply(constructed_library_calls,
       function(a_mandatory_library){
         write(a_mandatory_library,
               file = path(project_path, mspm::project_structure("file_packages")),
               append = TRUE)
         }
      )

  message("")
  message(paste("Create files:"))
  message("")
  message(paste("* in:", project_path))
  message("---")

  file_create(path(project_path, mspm::project_structure("file_packages")))
  file_create(path(project_path, mspm::project_structure("file_metadata_checkpoint")))
  file_create(path(project_path, mspm::project_structure("file_metadata_author")))
  file_create(path(project_path, mspm::project_structure("file_metadata_license")))
  file_create(path(project_path, mspm::project_structure("file_library_main")))
  file_create(path(project_path, mspm::project_structure("file_library_import_data")))
  file_create(path(project_path, mspm::project_structure("file_library_clean_data")))
  file_create(path(project_path, mspm::project_structure("file_library_transform_data")))
  file_create(path(project_path, mspm::project_structure("file_library_visualise_data")))
  file_create(path(project_path, mspm::project_structure("file_library_model_data")))
  file_create(path(project_path, mspm::project_structure("file_workflow_main")))
  file_create(path(project_path, mspm::project_structure("file_workflow_scratchpad")))
  file_create(path(project_path, mspm::project_structure("file_workflow_import_data")))
  file_create(path(project_path, mspm::project_structure("file_workflow_clean_data")))
  file_create(path(project_path, mspm::project_structure("file_workflow_transform_data")))
  file_create(path(project_path, mspm::project_structure("file_workflow_visualise_data")))
  file_create(path(project_path, mspm::project_structure("file_workflow_model_data")))

  system_date_for_checkpoint = list(checkpoint = Sys.Date())
  write_list_to_dcf(system_date_for_checkpoint, path(project_path, mspm::project_structure("file_metadata_checkpoint")))

  message("")
  message(paste("Install packages:"))
  message("")
  message(paste("* in:", project_path))
  message("---")

  wd_before = getwd()
  repo_before = getOption("repos")
  enable_project(project_path = project_path)
  install.packages(devtools)
  install_github("ctpfaff/mspm", subdir = "mspm")
  # install additional packages which do not get installed by enable
  setwd(wd_before)
  options(repos = repo_before)

  message("")
  message("Done:")
  message("")
  message("You can use the fuction enable_project() to initialize it for usage.")
  message("--------------------------")
}
