setup_rstudio <- function(path, ...) {
  require(yspm)
  arg.list <- list(root_path = path(path), ...)
  do.call(yspm::setup, arg.list)
}
