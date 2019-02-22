#' Clean up the source code of your project
#'
#' A small wrapper to the nice styler package which allows you easily style
#' the source code of your whole project for better readability.
#'
#' @examples
#' \dontrun{
#' enable_project(...)
#'
#' style_active_project()
#' }
#'
#' @importFrom styler style_dir
#'
#' @export style_active_project

style_active_project <- function(){
    check_if_project_is_enabled()
    style_dir(getwd())
}

