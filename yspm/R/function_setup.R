#' A function to setup a project mangement workspace
#'
#' It makes sense to have all your R projects in a single location to keep a
#' better overview and simply their management. This function initizlizes such a
#' location and fils the file with example content to get you started.
#' You can place the project mangement in any folder you like. It makes sense
#' to place this e.g. somewhere in your users home directory.
#'
#' @importFrom fs path dir_create file_create dir_exists
#'
#' @export setup_project_managment
setup_project_managment <- function(root_path = NULL){
    if(is.null(root_path)){
        stop("setup failed: it requies the parameter root_folder as otherwise it does not know wehre to set things up.")
    }
    if(dir_exists(root_path)){
        stop("setup failed: the root_folder that you provide already exists!")
    }
    dir_create(root_path)
    file_create(path(root_path), "manage_projects.R")

    write(content_setup_manage_projects, file = path(root_path, "manage_projects", ext = "R"))
}
