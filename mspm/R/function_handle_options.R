#' Get and set options for the package
#'
#' the package has an own environment with a list of options.
#' it is storing e.g. paths to folders and files in the project
#' structure the mspm package generates. It will be used by the
#' package itself to enable a project structure awareness throughout
#' the mspm package and allows convenient functions for users to
#' reference locations and files while writing conducting their
#' analysis using the project template.
#'
#' @param ... Pass in arbitrary names of options in the named list.
#'        to query for the value. Pass in a name and a value to set
#'        the value to your liking.
#'
#' @examples
#' \dontrun{
#'  # query
#'  agwdm::handle_options("xyz")
#'  # set
#'  agwdm::handle_options("xyz" = "value")
#' }
#'
#' @export handle_options

handle_options = function(...) {
  lst = list(...)
  .mspm.opts <- .mspm.env$.mspm.opts
  if(length(lst)) {
    if(is.null(names(lst)) && !is.list(lst[[1]])) {
      lst = unlist(lst)
      if(length(lst) == 1) .mspm.opts[[lst]] else .mspm.opts[lst]
    }
    else {
      omf = .mspm.opts
      if (is.list(lst[[1]]))
        lst = lst[[1]]
      if (length(lst) > 0) {
        .mspm.opts[names(lst)] <- lapply(lst, gsub, pattern = "\\s", replacement="")
        .mspm.env$.mspm.opts <- .mspm.opts
      }
      invisible(omf)
    }
  }
  else {
    .mspm.opts
  }
}

.mspm.env = new.env()
