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
#' create_project_name(first_name = "Max",
#'                      last_name = "Mustermann",
#'                      project_category = "PhD")
#' }
#'
#' @importFrom stringr str_detect str_to_lower str_replace_all
#'
#' @export compile_project_name

compile_project_name <- function(project_date = as.character(Sys.Date()), first_name = NULL, last_name = NULL, project_category = NULL){
  # errors
  if(missing(first_name)){
    stop("compile_project_name: requires the argument first_name")
  }
  if(missing(last_name)){
    stop("compile_project_name: requires the argument last_name")
  }
  # sanitize input
  first_name =
    str_to_lower(str_replace_all(str_trim(str_replace_all(str_replace_all(first_name, "[[:punct:]]", " "), "\\s+", " "), side = "both"), "\\s", "_"))
  last_name =
    str_to_lower(str_replace_all(str_trim(str_replace_all(str_replace_all(last_name, "[[:punct:]]", " "), "\\s+", " "), side = "both"), "\\s", "_"))
  # return
  if(missing(project_category)){
    return(paste(c(as.character(project_date), first_name, last_name), collapse = "_"))
  } else {
    project_category =
      str_to_lower(str_replace_all(str_trim(str_replace_all(str_replace_all(project_category, "[[:punct:]]", " "), "\\s+", " "), side = "both"), "\\s", "_"))
    return(paste(c(as.character(project_date), first_name, last_name, project_category), collapse = "_" ))
  }
}
