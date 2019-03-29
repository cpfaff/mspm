#' Find the main script of a project
#'
#' It collects all script files in the scource directory and check if the are
#' referencing each other. It returns the name of the script file which has the
#' greates count of mentioning other scripts. This is likely the main script to be
#' called execute the project. The function takes into account R as well as
#' R-Markdown files in the workflow folder in the source directory.
#'
#' @param path A path to the folder to search for the main script in. This defaults
#'        to the workflow folder of the project.
#'
#' @return The function returns a string with the name of the main script
#'

detect_main_script <- function(path = yspm::project_structure("folder_source_workflow")){

    the_function = match.call()[[1]]

    check_if_project_is_enabled(the_function)

    file_names <- 
      basename(list.files(path, 
                 pattern = ".*(r|rmd)$", 
                 ignore.case = T,
                 recursive = T))

    file_contents <-
      lapply(path(path(yspm::enabled_project()$project_path, 
                       yspm::project_structure("folder_source_workflow")), 
                  file_names), 
             FUN = readLines
    )

    file_contents <- 
      lapply(file_contents, 
             function(file_names){
               file_names[file_names != ""]
      })

    file_names_pattern <- 
      paste0("(", paste0(paste0("(?<=(\"|'|\\())", 
                         file_names, "(?=(\"|'|\\)))"), 
                       collapse = "|"), ")")

    file_names_found_in_file_content <-
      name_list_elements_after_file_names(a_list = lapply(lapply(file_contents, 
                    function(content){
                      regmatches(content, regexpr(file_names_pattern, content, perl = T))
                    }), 
             function(element){
               element[!is.na(element)]
             }), the_names = file_names)

    count_of_file_names_found_in_each_file_content <-
      unname(unlist(lapply(file_names_found_in_file_content, length), recursive = T))

    main_script_name <- 
      file_names[get_index_of_main_script(count_of_file_names_found_in_each_file_content)]

    return(main_script_name)
}

#' Detect scripts which are not interlinked with other scripts
#'
#' It collects all script files in the scource directory and check if the are
#' referencing each other. It returns the names of the scripts which are not 
#' mentioned by other scripts. They are either unused scripts in the project, or
#' the exist for a a specific purpose. However, we cannot guess their function
#' and the order of execution to make the whole project work is unclear.
#'
#' @param path A path to the folder to search for the main script in. This defaults
#'        to the workflow folder of the project.
#'
#' @return The function returns a string with the names script files which are not
#'         mentioned by others.
#'

detect_unused_scripts <- function(path = yspm::project_structure("folder_source_workflow")){

    the_function = match.call()[[1]]

    check_if_project_is_enabled(the_function)

    file_names <- 
      basename(list.files(path, 
                 pattern = ".*(r|rmd)$", 
                 ignore.case = T, 
                 recursive = T))

    file_contents <-
      lapply(path(path(yspm::enabled_project()$project_path, 
                       yspm::project_structure("folder_source_workflow")), 
                  file_names), 
             FUN = readLines
    )

    file_contents <- 
      lapply(file_contents, 
             function(file_names){
               file_names[file_names != ""]
      })

    file_names_pattern <- 
      paste0("(", paste0(paste0("(?<=(\"|'|\\())", 
                         file_names, "(?=(\"|'|\\)))"), 
                       collapse = "|"), ")")

    file_names_found_in_file_content <-
      name_list_elements_after_file_names(a_list = lapply(lapply(file_contents, 
                    function(content){
                      regmatches(content, regexpr(file_names_pattern, content, perl = T))
                    }), 
             function(element){
               element[!is.na(element)]
             }), the_names = file_names)

    count_of_file_names_found_in_each_file_content <-
      unname(unlist(lapply(file_names_found_in_file_content, length), recursive = T))

    unused_scripts_names <-
      file_names[get_index_of_disconnected_scripts(count_of_file_names_found_in_each_file_content)]

    return(unused_scripts_names)
}


#' Detect dataset usage in a project
#'
#' It collects all names of the data files and script files in the data and scource
#' directory and check if there are references inthe scripts to the data. It returns 
#' the name of the dataset file which has been used the most often. This is likely 
#' the main data of the project. The function takes into account R scripts as well as
#' R-Markdown files in the workflow folder in the source directory and all files in
#' the data folder.
#'
#' @param data_path A path to the folder to search for the data in. This defaults
#'        to the data folder of the project.
#'
#' @param script_path A path to the folder to search for the scripts in. This defaults
#'        to the workflow folder of the project.
#'
#' @return The function returns named vector pointing out dataset usage in scripts
#'

detect_data_usage <- function(data_path = yspm::project_structure("folder_data"), script_path = yspm::project_structure("folder_source_workflow")){
 
    the_function = match.call()[[1]]

    check_if_project_is_enabled(the_function)

    data_file_names <- 
      basename(list.files(data_path, 
                 pattern = ".*$", 
                 ignore.case = T,
                 recursive = T))

    script_file_names <- 
      basename(list.files(script_path, 
                 pattern = ".*(r|rmd)$", 
                 ignore.case = T,
                 recursive = T))

    script_file_contents <-
      lapply(path(path(yspm::enabled_project()$project_path, 
                       yspm::project_structure("folder_source_workflow")), 
                  script_file_names), 
             FUN = readLines
    )

    script_file_contents <- 
      lapply(script_file_contents, 
             function(file_names){
               file_names[file_names != ""]
      })

    data_file_names_pattern <- 
      paste0("(", paste0(paste0("(?<=(\"|'|\\())", 
                         data_file_names, "(?=(\"|'|\\)))"), 
                       collapse = "|"), ")")

    data_file_names_found_in_file_content <-
      name_list_elements_after_file_names(a_list = lapply(lapply(script_file_contents, 
                    function(content){
                      regmatches(content, regexpr(data_file_names_pattern, content, perl = T))
                    }), 
             function(element){
               element[!is.na(element)]
             }), the_names = script_file_names)

    dataset_usage <- 
        table(unlist(data_file_names_found_in_file_content))

    return(dataset_usage)
}
