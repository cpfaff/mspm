# generate a random string
#
# This creates a random string of specified length
# Can be use in testing e.g. to create folder and filenames.
#
random_string <- function(n = 1, lenght = 12) {
  randomString <- c(1:n)
  for (i in 1:n)
  {
    randomString[i] <- paste(sample(c(0:9, letters, LETTERS),
      lenght,
      replace = TRUE
    ),
    collapse = ""
    )
  }
  return(randomString)
}

# silence a funtion
#
# This is helpful to suppress the output of a function on screen.
#
quiet <- function(x) {
  sink(tempfile())
  on.exit(sink())
  invisible(force(x))
}

# define big message pseudo ui
#
big_message <- function(say) {
  message("========================================O")
  message(say)
  message("========================================O")
  message("")
}

# define small message pseudo ui
#
small_message <- function(say) {
  message("")
  message(say)
  message("--------------------------")
  message("")
}

# Converts a DCF file into an R list.
#
# This function will read a DCF file and translate the resulting
# data frame into a list.
#
# The contents of the DCF file are stored as character strings.
# If the content is placed between the back tick character,
# then the content is evaluated as R code and the result returned
# in a string
#
# @param filename Is a character vector specifying the DCF file to be
#   translated.
#
# @return Returns a list containing the entries from the DCF file.
#
# @export
#
# @examples
# library('ProjectTemplate')
#
# \dontrun{translate.dcf(file.path('config', 'global.dcf'))}

#' @importFrom stats setNames

read_dcf_to_list <- function(filename) {
  settings <- read.dcf(filename)
  settings <- setNames(as.list(as.character(settings)), colnames(settings))

  # Check each setting to see if it contains R code or a comment
  for (s in names(settings)) {
    if (grepl("^#", s)) {
      settings[[s]] <- NULL
      next
    }
    value <- settings[[s]]
    r_code <- gsub("^`(.*)`$", "\\1", value)
    if (nchar(r_code) != nchar(value)) {
      settings[[s]] <- eval(parse(text = r_code))
    }
  }
  settings
}

# Converts a list into a DCF file.
#
# This function will talk an R list and convert write it to a
# data dcf file.
#
# The contents of the DCF file are stored as character strings.
#
# @param filename Is a character vector specifying the DCF file to be
#   written.
#
# @return Nothing. The function is called for its side effects.
#
# @export

write_list_to_dcf <- function(list, filename) {
  database_input <- lapply(list, function(x) paste0(x, collapse = ","))
  quiet(write.dcf(database_input, filename))
}


# a directory tree
show_project_tree <- function(path = getwd(), level = Inf) {
  fad <-
    list.files(path = path, recursive = TRUE, no.. = TRUE, include.dirs = TRUE)
  fad_split_up <- strsplit(fad, "/")
  too_deep <- lapply(fad_split_up, length) > level
  fad_split_up[too_deep] <- NULL
  jfun <- function(x) {
    n <- length(x)
    if (n > 1) {
      x[n - 1] <- "|__"
    }
    if (n > 2) {
      x[1:(n - 2)] <- "   "
    }
    x <- if (n == 1) c("-- ", x) else c("   ", x)
    x
  }
  fad_subbed_out <- lapply(fad_split_up, jfun)
  cat(unlist(lapply(fad_subbed_out, paste, collapse = "")), sep = "\n")
}


# get the sourced file name
get_sourced_file_directory <- function() {
  cmdArgs <- commandArgs(trailingOnly = FALSE)
  needle <- "--file="
  match <- grep(needle, cmdArgs)
  if (length(match) > 0) {
    # Rscript
    return(dirname(normalizePath(sub(needle, "", cmdArgs[match]))))
  } else {
    # 'source'd via R console
    return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  }
}

# file contents
content_setup_manage_projects <- '# Make sure that the working directory is set to the directory of this file.
# Afterwards you can start managing your r projects with yspm.

# check where you are
getwd()

# if we are not in the right directory set it now
# setdw(<your projects directory>)

# load the project mangement package
library(yspm)

# create a new project
create_project(project_name = compile_project_name(first_name = "Claas-Thido",
                                                   last_name = "Pfaff",
                                                   project_category = "PhD"))

# enable a project
enable_project(project_name = compile_project_name(first_name = "Claas-Thido",
                                                   last_name = "Pfaff",
                                                   project_category = "PhD"))

# shows info for the enabled project
enabled_project()

# shows the folder structure and files in the active project
project_content()
'

# check if a project is enabled.
# all functions that act on a project can use it to be sure that they can act on a project.
check_if_project_is_enabled <- function(function_name) {
  if (is.null(enabled_project("project_path"))) {
    stop(paste("the function", function_name, ": can only work when a project is enabled."))
  }
}
