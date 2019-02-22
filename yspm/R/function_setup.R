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
setup <- function(root_path = NULL){
  if(is.null(root_path)){
    stop("setup failed: it requies the parameter root_folder as otherwise it does not know wehre to set things up.")
  }
  if(dir_exists(root_path)){
    stop("setup failed: the root_folder that you provide already exists!")
  }

  big_message("Setup project management")

  small_message("Create content")

  message(paste("* create folder:", root_path))

  dir_create(root_path)

  message(paste("* create file manage_projects.R in :", root_path))

  file_create(path(root_path), "manage_projects.R")

  write(content_setup_manage_projects, file = path(root_path, "manage_projects", ext = "R"))

  message("")
  message("Done:")
  message("")
  message(paste("Open manage_projects.R in:", root_path, "with your favorite editor to get started."))
  message("--------------------------")
}
