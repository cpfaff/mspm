#' A fuction to compile project paths
#'
#' This function compiles a project path which is always constructued
#' from the root folder of the project. As the predefined folder structure
#' has the folder "project" on top this is taken as the root inside the
#' actual project name. This makes the project more self contained and
#' allows references to files which do not break.
#'
#' @importFrom fs path dir_exists file_exists
#'
#' @export reference_content

reference_content <- function(path = NULL){
    if(is.null(enabled_project("project_path"))){
        stop("the function reference_content: is only working when a project enabled.")
    }
    if(is.null(path)){
        stop("the function reference_content: requires a path to the file or folder you want to reference")
    }

    is_the_reference_a_file = file_exists(path(enabled_project("project_path"), "project", path))
    is_the_reference_a_folder = dir_exists(path(enabled_project("project_path"), "project", path))

    if(!all(is_the_reference_a_file, is_the_reference_a_folder)){
        stop("the function reference_content: seems to point to nowhere the file or directory does not exist")
    }

    return(path(enabled_project("project_path"), "project", path))
}
