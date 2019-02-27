#' Clean up the source code of your project
#'
#' A small wrapper to the styler package which allows you easily standarize
#' the source code of your whole project using the tidyverse style guide
#' to improve code readability. The corrections include spacing, indentation,
#' the use of the right assignment operator... etc.
#'
#' @param project_path Is the full path to the folder in which the active
#'        project resides in.
#'
#' @examples
#' \dontrun{
#' enable_project(...)
#' 
#' style_project()
#' }
#' 
#' @importFrom styler style_dir
#' @importFrom fs path
#' @export standardize_project_code

standardize_project_code <- function(project_path = yspm::enabled_project("project_path")) {
  project_path <- suppressWarnings(normalizePath(path(project_path)))
  suppressWarnings(style_dir(project_path))
}
