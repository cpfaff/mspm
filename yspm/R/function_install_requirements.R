#' A function to list packages used in a project
#'
#' You can call the function to list all packages that are reference in
#' the source code of your project. This function is also used during enabling
#' a project to ensure all requirements are installed. The function detects
#' all calls to library(), require(), import::from().
#'
#' @param root_path The path to the project.
#' @param path Provide the path folder all scripts are located in.
#'
#' @importFrom stringr str_extract_all
#' @export list_requirements
#
list_requirements <- function(root_path, path = yspm::project_structure("folder_source")) {

  path <- suppressWarnings(normalizePath(path(root_path, path)))

  list_of_files <-
    list.files(path = path, recursive = T, ignore.case = T, pattern = "*.(r|rmd)$")

  list_of_files_with_path <-
    lapply(list_of_files, function(file_name) path(path, file_name))

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
        str_extract_all(vector_of_file_content, "(?<!^#.{1,5000})(?<=(library\\((\"|')?|require\\((\"|')?))[A-z]+(?=(,|\"|'|\\)))"),
        str_extract_all(vector_of_file_content, "(?<!^#.{1,5000})(?<=(import::(from)\\((\"|')?))[A-z]+(?=(,|\"|'|\\)))"),
        str_extract_all(vector_of_file_content, "(?<!^#.{1,5000})\\w[A-z]+(?=:{2,3}(?!from))")
      )))

    return(required_packages)
  }
}

# A function to install packages which are not yet installed
#
# You can call the function to install all packages in which are not yet
# installed in any of your active library paths. Is is used when a project
# is enabled to ensure that all requirements are installed.  
#
# @param path Provide the path folder all scripts are located in.
#
# @export install_requirements
#
# install_requirements <- function(path = yspm::project_structure("folder_source")) {
  # path <- suppressWarnings(normalizePath(path(path)))

# path = yspm::project_structure("folder_source")
  # path <- suppressWarnings(normalizePath(path(path)))
  # the_function <- match.call()[[1]]
  # check_if_project_is_enabled(the_function)

    # local_packages <- rownames(installed.packages())
    # package_count <- length(setdiff(required_packages, local_packages))

    # if (package_count > 0) {
      # if (!all(required_packages %in% local_packages)) {
        # small_message("Installing")
        # message("")
        # message(paste("* package count:", package_count))
        # message("---")
        # message("")

        # for (package in setdiff(required_packages, local_packages)) {
          # message(paste("* package:", package))
        # }

        # install.packages(unlist(setdiff(required_packages, local_packages)))
      # }
    # }

