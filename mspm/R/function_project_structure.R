#' Query locations of folder and files
#'
#' @param ... Pass in the names of available folders and files to query
#'        for their locationl
#'
#' @examples
#' \dontrun{
#'  # list all
#'  agwdm::project_structure()
#' }
#'
#' @export project_structure

project_structure = function(...) {
  lst = list(...)
  .mspm.project_structure <- .mspm.env$.mspm.project_structure
  if(length(lst)) {
    if(is.null(names(lst)) && !is.list(lst[[1]])) {
      lst = unlist(lst)
      if(length(lst) == 1) .mspm.project_structure[[lst]] else .mspm.project_structure[lst]
    }
    else {
      omf = .mspm.project_structure
      if (is.list(lst[[1]]))
        lst = lst[[1]]
      if (length(lst) > 0) {
        .mspm.project_structure[names(lst)] <- lapply(lst, gsub, pattern = "\\s", replacement="")
        .mspm.env$.mspm.project_structure <- .mspm.project_structure
      }
      invisible(omf)
    }
  }
  else {
    .mspm.project_structure
  }
}
