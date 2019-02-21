setup_rstudio <- function(path, ...) {
  require(mspm)
  arg.list <- list(root_folder = path(path), ...)
  do.call(mspm::setup,arg.list)
}
