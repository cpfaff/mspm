#' A function to list packages used in a project
#'
#' You can call the function to list all packages that are reference in
#' the source code of your project. This function is also used during enabling
#' a project to ensure all requirements are installed. The function detects
#' all calls to library(), require(), import::from().
#'
#' @param search_path Provide the path to a folder all your scripts are located 
#'        in. This can be e.g. the root directory of a project. The function 
#'        searches recursively all folders for R and R-Markdown files.
#'
#' @importFrom stringr str_extract_all
#' @export list_requirements
#
list_requirements <- function(search_path = getwd()) {
  search_path <- suppressWarnings(normalizePath(file.path(search_path)))

  list_of_files <-
    list.files(path = search_path, recursive = T, ignore.case = T, pattern = "*.(r|rmd)$")

  list_of_files_with_path <-
    lapply(list_of_files, function(file_name) file.path(search_path, file_name))

  if (length(list_of_files) > 0) {
    big_message("List requirements")
    small_message("Scanning files")

    for (file in basename(unlist(list_of_files_with_path))) {
      message(paste("* file:", file))
    }

    vector_of_file_content <-
      unlist(sapply(list_of_files_with_path, function(file) {
        readLines(file)
      }), use.names = F)

    required_packages <-
      unique(Filter(length, c(
        str_extract_all(vector_of_file_content, "(?<!^#.{1,5000})(?<=(library\\((\"|')?|require\\((\"|')?))[A-z0-9]+(?=(,|\"|'|\\)))"),
        str_extract_all(vector_of_file_content, "(?<!^#.{1,5000})(?<=(import::(from)\\((\"|')?))[A-z0-9]+(?=(,|\"|'|\\)))"),
        str_extract_all(vector_of_file_content, "(?<!^#.{1,5000})\\w[A-z0-9]+(?=:{2,3}(?!from))")
      )))

    return(required_packages)
  }
}

#' A function to install packages which are not yet installed 
#'
#' You can call the function to install all packages you pass in the names of
#' which are not yet installed in any of your active library paths. Is is used
#' together with list_requirements when a project is enabled to ensure that all 
#' the required dependencies are installed.  
#'
#' @param packages a vector or list providing all package names to be installed.
#'
#' @export install_requirements
#
install_requirements <- function(packages) {
  the_function <- match.call()[[1]]
  check_if_project_is_enabled(the_function)

  local_packages <- rownames(installed.packages())
  package_count <- length(setdiff(packages, local_packages))

    if (package_count > 0) {
      if (!all(packages %in% local_packages)) {
        small_message("Installing")
        message("")
        message(paste("* package count:", package_count))
        message("---")
        message("")

        for (package in setdiff(packages, local_packages)) {
          message(paste("* package:", package))
        }

        install.packages(unlist(setdiff(packages, local_packages)))
      }
    }
}

