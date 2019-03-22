#' A function that allows building modular projects
#'
#' Each project is different and everybody has a different taste and needs of
#' packages. Thus the yspm is modular allowing to script each project to your
#' needs. It here uses a similar approach to the the use_this package. Calling
#' the function will add packages and content to your active project to enable
#' certain functionality.
#'
#' @param feature This allows adjusting whwat will be done later... e.g. inserting
#'        a package into a project.

#' @export use_that
use_that <- function(feature) {
  if ("drake" %in% feature) {
    print("adding drake package to your packages")
    print("install the drake package")
  }
}
