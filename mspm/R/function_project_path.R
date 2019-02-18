#' A fuction to compile project paths
#'
#' This function compiles a project path which is always constructued
#' from the root folder of the project. As the predefined folder structure
#' has the folder "project" on top this is taken as the root inside the
#' actual project name. This makes the project more self contained and
#' allows references to files which do not break.
#'
#' @param path The path to the file or folder inside the project.
#'
#' @return a string path pointing to the file or folder
#'
#' @examples
#' \dontrun{
#'  project_content("data/raw/iris.csv")
#'      "project_name/project/data/raw/iris.csv"
#' }
#'
#' @importFrom fs path
#'
#' @export project_content

project_content <- function(path = NULL){
    if(is.null(enabled_project("project_path"))){
        stop("the function project_content: can only work when a project enabled.")
    }
    if(is.null(path)){
        stop("the function project_content: requires a path to the file or folder you want to reference")
    }

    path(enabled_project("project_path"), "project", path)
}
