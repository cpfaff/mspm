#' Project overview
#'
#' This functions provides a tree like representation of the folder structure and
#' all the files which reside in an activated projec like the linux command line
#' tool called tree. It helps to gain a fast overview about a project.
#'
#' @return The function is called for its side effects. 
#'
#' @examples
#' \dontrun{
#' show_content()
#' project
#' data
#' ...
#' ...
#' }
#' 
#' @importFrom fs path
#'
#' @export show_content 

show_content <- function() {
  check_if_project_is_enabled()
  project_tree(path = path(yspm::enabled_project("project_path")))
}

#' Link to project content like files and folders
#'
#' This function compiles paths from the root folder of the enabled project.
#' This allows to prevent calls to setwd() setting the working directory for 
#' the script and thus to create more self-contained shareable R projects.
#' The function does not check if the file or folder exists. You have to 
#' ensure this. While you notice it right away when you are using the function
#' to reference e.g. data to read into R you might not notice it right away
#' when writing.
#'
#' @examples
#' \dontrun{
#' link_to_content("data/01_primary")
#' # returns
#' <project_folder_name>/project/data/01_primary
#' }
#' 
#'
#' @param path The path to the file or folder inside the project that is to be
#'        referenced. You can start referencing for
#'
#' @return a string path pointing to the file or folder or when called
#'         without arguments an overview about the structure and files of the
#'         project

#' @export link_content

link_content <- function(path = NULL) {
  check_if_project_is_enabled()
  if (is.null(path)) {
    stop("You need to provide a path to create a reference")
  } else {
    path(enabled_project("project_path"), "project", path)
  }
}
