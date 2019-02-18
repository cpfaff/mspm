#' Query information about the active project
#'
#' @param ... Pass in the names of available information pieces see
#'        example.
#'
#' @examples
#' \dontrun{
#'  # list all
#'  agwdm::enabled_project()
#'  # get the active project checkpoint
#'  agwdm::enabled_project("project_checkpoint")
#' }
#'
#' @export enabled_project

enabled_project = function(...) {
  lst = list(...)
  .mspm.enabled_project <- .mspm.env$.mspm.enabled_project
  if(length(lst)) {
    if(is.null(names(lst)) && !is.list(lst[[1]])) {
      lst = unlist(lst)
      if(length(lst) == 1) .mspm.enabled_project[[lst]] else .mspm.enabled_project[lst]
    }
    else {
      omf = .mspm.enabled_project
      if (is.list(lst[[1]]))
        lst = lst[[1]]
      if (length(lst) > 0) {
        .mspm.enabled_project[names(lst)] <- lapply(lst, gsub, pattern = "\\s", replacement="")
        .mspm.env$.mspm.enabled_project <- .mspm.enabled_project
      }
      invisible(omf)
    }
  }
  else {
    .mspm.enabled_project
  }
}

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

.mspm.env = new.env()
