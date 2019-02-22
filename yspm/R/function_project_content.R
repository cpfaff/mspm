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
#' @return a string path pointing to the file or folder or when called
#'         without arguments an overview about the structure and files of the
#'          project
#'
#' @examples
#' \dontrun{
#' project_content("data/raw/iris.csv")
#' "project_name/project/data/raw/iris.csv"
#' project_content()
#' project
#' data
#' ...
#' ...
#' }
#'
#' @importFrom fs path
#'
#' @export project_content

project_content <- function(path = NULL) {
  check_if_project_is_enable()
  if (is.null(path)) {
    show_project_tree(path = path(enabled_project("project_path")))
  } else {
    path(enabled_project("project_path"), "project", path)
  }
}
