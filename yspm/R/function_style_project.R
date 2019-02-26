#' Clean up the source code of your project
#'
#' A small wrapper to the nice styler package which allows you easily style
#' the source code of your whole project for better readability.
#'
#' @examples
#' \dontrun{
#' enable_project(...)
#' 
#' style_project()
#' }
#' 
#' @importFrom styler style_dir
#' @export style_project

style_project <- function(path = yspm::enabled_project("project_path")) {
  check_if_project_is_enabled()
  suppressWarnings(style_dir(path))
}
