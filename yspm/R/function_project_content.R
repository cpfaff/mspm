#' Project overview
#'
#' This functions provides a tree like overview about the folder structure
#' and files which reside in an activated project.
#'
#' @return Called for its side effects. A tree with folders and files
#'         is shown
#'
#' @examples
#' \dontrun{
#' show_content()
#' project
#' data
#' ...
#' ...
#'}
#'
#' @importFrom fs path
#'
#' @export show_content

show_content <- function() {
  check_if_project_is_enabled()
  project_tree(path = path(yspm::enabled_project("project_path")))
}

#' Project references
#'
#' This function allows to compile relative paths from the root folder of the
#' enabled project. This prevents setwd() calls and allows to create shareable
#' projects.
#'
#' @param path The path to the file or folder inside the project that is to be
#'        referenced.
#'
#' @return a string path pointing to the file or folder or when called
#'         without arguments an overview about the structure and files of the
#'          project

#' @export reference_content

reference_content <- function(path = NULL) {
  check_if_project_is_enabled()
  if (is.null(path)) {
    stop("You need to provide a path to create a reference")
  } else {
    path(enabled_project("project_path"), "project", path)
  }
}
