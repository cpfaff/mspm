#' A fuction to compile project paths
#'
#' This function compiles a project path which is always constructued
#' from the root folder of the project. As the predefined folder structure
#' has the folder "project" on top this is taken as the root inside the
#' actual project name. This makes the project more self contained and
#' allows references to files which do not break.
#'
#' @importFrom fs path
#'
#' @export reference_content

reference_content <- function(path = NULL){
    if(is.null(enabled_project("project_path"))){
        stop("the function reference_content: is only working when a project enabled.")
    }
    if(is.null(path)){
        stop("the function reference_content: requires a path to the file or folder you want to reference")
    }
    return(path(enabled_project("project_path"), "project", path))
}
