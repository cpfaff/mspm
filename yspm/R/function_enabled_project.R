#' Query information about the active project
#'
#' @param ... Pass in the names of available information pieces see
#'        example.
#'
#' @examples
#' \dontrun{
#' # list all
#' agwdm::enabled_project()
#' # get the active project checkpoint
#' agwdm::enabled_project("project_checkpoint")
#' }
#' 
#' @export enabled_project

enabled_project <- function(...) {
  lst <- list(...)
  .yspm.enabled_project <- .yspm.env$.yspm.enabled_project
  if (length(lst)) {
    if (is.null(names(lst)) && !is.list(lst[[1]])) {
      lst <- unlist(lst)
      if (length(lst) == 1) .yspm.enabled_project[[lst]] else .yspm.enabled_project[lst]
    }
    else {
      omf <- .yspm.enabled_project
      if (is.list(lst[[1]])) {
        lst <- lst[[1]]
      }
      if (length(lst) > 0) {
        .yspm.enabled_project[names(lst)] <- lapply(lst, gsub, pattern = "\\s", replacement = "")
        .yspm.env$.yspm.enabled_project <- .yspm.enabled_project
      }
      invisible(omf)
    }
  }
  else {
    .yspm.enabled_project
  }
}

#' Query locations of folder and files
#'
#' @param ... Pass in the names of available folders and files to query
#'        for their locationl
#'
#' @examples
#' \dontrun{
#' # list all
#' agwdm::project_structure()
#' }
#' 
#' @export project_structure

project_structure <- function(...) {
  lst <- list(...)
  .yspm.project_structure <- .yspm.env$.yspm.project_structure
  if (length(lst)) {
    if (is.null(names(lst)) && !is.list(lst[[1]])) {
      lst <- unlist(lst)
      if (length(lst) == 1) .yspm.project_structure[[lst]] else .yspm.project_structure[lst]
    }
    else {
      omf <- .yspm.project_structure
      if (is.list(lst[[1]])) {
        lst <- lst[[1]]
      }
      if (length(lst) > 0) {
        .yspm.project_structure[names(lst)] <- lapply(lst, gsub, pattern = "\\s", replacement = "")
        .yspm.env$.yspm.project_structure <- .yspm.project_structure
      }
      invisible(omf)
    }
  }
  else {
    .yspm.project_structure
  }
}

.yspm.env <- new.env()
