#' A function to crawl for required packages in a project
#'
#' If we load a project we do not know which packages are
#' required to run it. This function detects all references which
#' are made to packages in the project. Then it checks of they are
#' existing in the project library. If not they are finally
#' installed.
#' @param path Provide the path folder all scripts are located in.
#' @importFrom stringr str_extract_all
#
install_requirements <- function(path = yspm::project_structure("folder_source")) {
  path <- suppressWarnings(normalizePath(path(path)))

  check_if_project_is_enabled("install_requirements")

  list_of_files <-
    normalizePath(list.files(path = path, recursive = T, ignore.case = T, pattern = "*.R"))

  list_of_files_with_path <-
    lapply(list_of_files, function(file_name) path(path, file_name))

  if (length(list_of_files) > 0) {
    big_message("Install requirements")
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

    local_packages <- rownames(installed.packages())
    package_count <- length(setdiff(required_packages, local_packages))

    if (package_count > 0) {
      if (!all(required_packages %in% local_packages)) {
        small_message("Installing")
        message("")
        message(paste("* package count:", package_count))
        message("---")
        message("")

        for (package in setdiff(required_packages, local_packages)) {
          message(paste("* package:", package))
        }

        install.packages(unlist(setdiff(required_packages, local_packages)))
      }
    }
  }
}