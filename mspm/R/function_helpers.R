# generate a random string
#
# This creates a random string of specified length
# Can be use in testing e.g. to create folder and filenames.
#
random_string <- function(n=1, lenght=12)
{
    randomString <- c(1:n)                  # initialize vector
    for (i in 1:n)
    {
        randomString[i] <- paste(sample(c(letters, LETTERS),
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

# compile a valid project name
#
# a helper to abstract away the checks for a valid folder name which
# when creating a project. The name is staring with the current date,
# is not allowed to contain special characters and needs to follow a
# snake case notation
#
# @importFrom stringr str_detect str_to_lower str_replace_all
#
compile_project_name <- function(current_date = Sys.Date(), first_name, last_name, degree){
  # errors
  ## arguments given
  if(missing(first_name)){
    stop("compile_project_name: requires the argument first_name")
  }
  if(missing(last_name)){
    stop("compile_project_name: requires the argument last_name")
  }
  if(missing(current_date)){
    stop("compile_project_name: requires the argument current_date")
  }
  ## content correct
  ### mandatory
  if(!str_detect(first_name, pattern = "^[\u00C0-\u017Fa-zA-Z_ ]+?")){
    stop("compile_project_name: first_name contains invalid characters: A-z letters are allowed and words are separated in snake_case or with spaces")
  }
  if(!str_detect(last_name, pattern = "^[\u00C0-\u017Fa-zA-Z_ ]+?")){
    stop("compile_project_name: last_name contains invalid characters: A-z letters are allowed and words are separated in snake_case with spaces")
  }
  ### optional
  if(!missing(degree)){
    if(!str_detect(degree, pattern = "^[\u00C0-\u017Fa-zA-Z_ ]+?")){
      stop("compile_project_name: last_name contains invalid characters: A-z letters are allowed and words are separated in snake_case")
    }
  }
  # function
  ## mandatory
  if(missing(degree)){
    return(
       paste(c(as.character(current_date),
               str_replace_all(str_replace_all(str_to_lower(first_name), "\\s+", " "), "\\s", "_"),
               str_replace_all(str_replace_all(str_to_lower(last_name), "\\s+", " "), "\\s", "_")), collapse = "_")
    )
  ## optional
  } else {
    return(
      paste(c(as.character(current_date),
              str_replace_all(str_replace_all(str_to_lower(first_name), "\\s+", " "), "\\s", "_"),
              str_replace_all(str_replace_all(str_to_lower(last_name), "\\s+", " "), "\\s", " "),
              str_replace_all(str_replace_all(str_to_lower(degree), "\\s+", " "), "\\s", " ")), collapse = "_")
    )
  }
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

