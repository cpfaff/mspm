#' Create a file name for a plot
#'
#' @importFrom snakecase as_snake_case
#' @export compile_plot_filename

compile_plot_filename <- function(name = NULL, extension = NULL) {
  check_if_project_is_enabled("compile_plot_filename")

  # errors
  if (missing(name)) {
    stop("plot_file_name: requires the argument name")
  }
  if (missing(extension)) {
    stop("plot_file_name: requires the argument extension")
  }

  return(path(
    normalizePath(reference_content("figure/scripted")),
    file.path(paste(c(
      as.character(snakecase::to_snake_case(name)),
      as.character(snakecase::to_snake_case(extension))
    ), collapse = "."))
  ))
}
