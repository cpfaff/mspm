#' A function to install packages #'
#'
#' A function which is installing packages without triggering the reload of the
#' environment in R-Studio. It is a wrapper around the install.packages
#' function. It checks for currently loaded packages, forces them to be detached
#' and attaches them again after your new packages have been installed.
#'
#' @param name A package name or character vector with package names
#' @return The function is called for its side effects
#' @export install_packages

install_packages <- function(name) {
  if (Sys.getenv("RSTUDIO") == "1") {
    message("")
    message(paste("Clean your workspace from packages:"))
    message("")

    loaded_packages <- names(sessionInfo()$otherPkgs)
    quiet(suppressWarnings(lapply(loaded_packages, function(package) {
      try(detach(paste0("package:", package), character.only = TRUE, unload = TRUE, force = TRUE), silent = T)
    })))
  }

  install.packages(name)

  if (Sys.getenv("RSTUDIO") == "1") {
    message("")
    message(paste("Restore your workspace with packages:"))
    message("")
    lapply(loaded_packages, require, character.only = TRUE)
  }
}
