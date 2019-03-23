#' Query locations of folder and files
#'
#' @param ... Pass in the names of available folders and files to query
#'        for their locationl
#'
#' @examples
#' \dontrun{
#' project_structure(...)
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
