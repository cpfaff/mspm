#' A function which helps to compile a project name
#'
#' Each project folder name starts with a date in the format of YYYY-MM-DD. This
#' should be followed by the name of the person which creates the project. After
#' the first and last name there can be a project category attached to the name as
#' well. All the naming should be small letters and follow a snake case notation
#' except for the date. An example folder name woujld be
#' 2019-01-01_max_mustermann_phd.
#'
#' @param project_date The date in YYYY-MM-DD format. The default is using the
#'        current date (mandatory).
#' @param first_name The first name. Provide the first name as it is. The function
#'        takes crea to clean it from special character and unwanted spaces, before
#'        it is turned into a snake case string (mandatory).
#' @param last_name The last name. Provide the last name as it is. The function
#'        takes crea to clean it from special character and unwanted spaces, before
#'        it is turned into a snake case string (mandatory).
#' @param project_category The category helps to clarify what the project is about.
#'        This is particularly useful when you have to tell which of your projects
#'        is behind a particular project folder
#'
#' @examples
#' \dontrun{
#' create_project_name(
#'   first_name = "Max",
#'   last_name = "Mustermann",
#'   project_category = "PhD"
#' )
#' }
#' 
#' @importFrom stringr str_detect str_to_lower str_replace_all str_trim
#'
#' @export compile_project_name

compile_project_name <- function(project_date = as.character(Sys.Date()), first_name = NULL, last_name = NULL, project_category = NULL) {
  # errors
  if (missing(first_name)) {
    stop("compile_project_name: requires the argument first_name")
  }
  if (missing(last_name)) {
    stop("compile_project_name: requires the argument last_name")
  }
  # sanitize input
  first_name <-
    str_to_lower(str_replace_all(str_trim(str_replace_all(str_replace_all(first_name, "[[:punct:]]", " "), "\\s+", " "), side = "both"), "\\s", "_"))
  last_name <-
    str_to_lower(str_replace_all(str_trim(str_replace_all(str_replace_all(last_name, "[[:punct:]]", " "), "\\s+", " "), side = "both"), "\\s", "_"))
  # return
  if (missing(project_category)) {
    return(paste(c(as.character(project_date), first_name, last_name), collapse = "_"))
  } else {
    project_category <-
      str_to_lower(str_replace_all(str_trim(str_replace_all(str_replace_all(project_category, "[[:punct:]]", " "), "\\s+", " "), side = "both"), "\\s", "_"))
    return(paste(c(as.character(project_date), first_name, last_name, project_category), collapse = "_"))
  }
}

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
#' compile_filename(name = "01 my first plot", extension = "PNG")
#' }
#' 
#' @importFrom snakecase to_snake_case
#' @export compile_filename

compile_filename <- function(name = NULL, extension = NULL) {
  the_function <- match.call()[[1]]
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
#' compile_plot_filename(name = "01 my first plot", extension = "PNG")
#' }
#' 
#' @importFrom snakecase to_snake_case
#' @export compile_plot_filename

compile_plot_filename <- function(name = NULL, extension = NULL) {
  the_function <- match.call()[[1]]
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
#' compile_data_filename(name = "01 my first data", extension = "PNG")
#' }
#' 
#' @importFrom snakecase to_snake_case
#' @export compile_data_filename

compile_data_filename <- function(name = NULL, extension = NULL) {
  the_function <- match.call()[[1]]
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
