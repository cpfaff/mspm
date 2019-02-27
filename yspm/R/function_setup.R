#' A function to setup a project mangement workspace
#'
#' It makes sense to have all your R projects in a single location to keep a
#' better overview and simply their management. This function initizlizes such a
#' location and fils the file with example content to get you started.
#' You can place the project mangement in any folder you like. It makes sense
#' to place this e.g. somewhere in your users home directory.
#'
#' @param root_path allows you to specify where the new project management
#'        folder will be created.
#'
#' @importFrom fs path dir_create file_create dir_exists
#'
#' @export setup

setup <- function(root_path = NULL) {
  if (is.null(root_path)) {
    stop("setup failed: it requies the parameter root_path as otherwise it does not know wehre to set things up.")
  }

  normalized_root_path <- suppressWarnings(normalizePath(path(root_path)))

  if (dir_exists(normalized_root_path)) {
    stop("setup failed: the root_path that you have provided already exists!")
  }

  big_message("Setup project management")

  small_message("Create content")

  message(paste("* folder:"))
  message("")
  message(paste(normalized_root_path))
  message("")

  dir_create(normalized_root_path)

  message(paste("* file:"))
  message("")
  message(paste("manage_projects.R"))
  message("")

  file_create(path(normalized_root_path, "manage_projects", ext = "R"))

  write(content_setup_manage_projects, file = path(normalized_root_path, "manage_projects", ext = "R"))

  message("")
  message("Done:")
  message("")
  message("Now you can open the manage_projects.R file in the path below to get started:")
  message("")
  message(normalized_root_path)
  message("")
  message("--------------------------")
}
