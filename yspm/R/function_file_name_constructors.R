#' Create file names for your project
#'
#' The package comes with family of functions which will help you with
#' referencing and naming content inside of a project. This provides you 
#' with an unobtrusive way to keep your project clean, while adhering to 
#' a unified naming schema. 
#'
#' @param name A filename to create for a plot. It will be forced to snake
#'        case.
#' @param extension The extension the file is using. This string will be 
#'        forced to lower case letters only and appended to the file 
#'        name.
#'
#' @return The function returns the constructed file name
#'
#' @examples
#' \dontrun{
#'  compile_filename(name = "01 my first plot", extension = "PNG")
#' }
#'
#' @importFrom snakecase to_snake_case
#' @export compile_filename 

compile_filename <- function(name = NULL, extension = NULL) {
  the_function = match.call()[[1]]
  check_if_project_is_enabled(the_function)

  # error checking
  if (missing(name)) {
    stop(paste(the_function, ": requires the argument name"))
  }
  if (missing(extension)) {
    stop(paste(the_function, ": requires the argument extension"))
  }

  return(paste(c(as.character(snakecase::to_snake_case(name)), as.character(tolower(extension))), collapse = "."))
}

#' Create a file name for a plot
#'
#' The package comes with family of functions which will help you with
#' referencing and naming content inside of a project. This provides you 
#' with an unobtrusive way to keep your project clean, while adhering to 
#' a unified naming schema. 
#'
#' @param name A filename to create for a plot. It will be forced to snake
#'        case and the name will be augmented with the path to folder that
#'        contains all R script generated plots in your project.
#' @param extension The extension the file is using. This string will be 
#'        forced to lower case letters only and appended to the file 
#'        name.
#' @return The function returns the constructed file path 
#'
#' @examples
#' \dontrun{
#'  compile_plot_filename(name = "01 my first plot", extension = "PNG")
#' }
#'
#' @importFrom snakecase to_snake_case
#' @export compile_plot_filename

compile_plot_filename <- function(name = NULL, extension = NULL) {
  the_function = match.call()[[1]]
  check_if_project_is_enabled(the_function)

  # error checking
  if (missing(name)) {
    stop(paste(the_function, ": requires the argument name"))
  }
  if (missing(extension)) {
    stop(paste(the_function, ": requires the argument extension"))
  }

  return(path(
    normalizePath(reference_content("figure/scripted")),
    file.path(paste(c(
      as.character(snakecase::to_snake_case(name)),
      as.character(tolower(extension))
    ), collapse = "."))
  ))
}


#' Create a file name for data
#'
#' The package comes with family of functions which will help you with
#' referencing and naming content inside of a project. This provides you 
#' with an unobtrusive way to keep your project clean, while adhering to 
#' a unified naming schema. 
#'
#' @param name A filename to create for your data. It will be forced to snake
#'        case and the name will be augmented with the path to folder that
#'        contains all your data.
#' @param extension The extension the file is using. This string will be 
#'        forced to lower case letters only and appended to the file 
#'        name.
#' @return The function returns the constructed file path 
#'
#' @examples
#' \dontrun{
#'  compile_data_filename(name = "01 my first data", extension = "PNG")
#' }
#'
#' @importFrom snakecase to_snake_case
#' @export compile_data_filename

compile_data_filename <- function(name = NULL, extension = NULL) {
  the_function = match.call()[[1]]
  check_if_project_is_enabled(the_function)

  # error checking
  if (missing(name)) {
    stop(paste(the_function, ": requires the argument name"))
  }
  if (missing(extension)) {
    stop(paste(the_function, ": requires the argument extension"))
  }

  return(path(
    normalizePath(reference_content("data")),
    file.path(paste(c(
      as.character(snakecase::to_snake_case(name)),
      as.character(tolower(extension))
    ), collapse = "."))
  ))
}
