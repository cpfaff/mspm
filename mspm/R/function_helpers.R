# generate a random string
#
# This creates a random string of specified length
# Can be use in testing e.g. to create folder and filenames.
#
random_string <- function(n=1, lenght=12)
{
    randomString <- c(1:n)
    for (i in 1:n)
    {
        randomString[i] <- paste(sample(c(0:9, letters, LETTERS),
                                        lenght, replace=TRUE),
                                 collapse="")
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
big_message <- function(say){
    message("========================================O")
    message(say)
    message("========================================O")
    message("")
}

# define small message pseudo ui
#
small_message <- function(say){
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

read_dcf_to_list <- function(filename)
{
  settings <- read.dcf(filename)
  settings <- setNames(as.list(as.character(settings)), colnames(settings))

  # Check each setting to see if it contains R code or a comment
  for (s in names(settings)) {
    if (grepl('^#', s)) {
      settings[[s]] <- NULL
      next
    }
    value <- settings[[s]]
    r_code <- gsub("^`(.*)`$", "\\1", value)
    if (nchar(r_code) != nchar(value)) {
      settings[[s]] <- eval(parse(text=r_code))
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

write_list_to_dcf <- function(list, filename)
{
  database_input <- lapply(list, function(x) paste0(x, collapse = ","))
  quiet(write.dcf(database_input, filename))
}
