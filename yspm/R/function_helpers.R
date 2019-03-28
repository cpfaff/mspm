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


# a directory tree structure
project_tree <- function(path = getwd(), level = Inf) {
  path <- suppressWarnings(normalizePath(path(path)))

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

# check if a project is enabled.
# all functions that act on a project can use it to be sure that they can act on a project.
check_if_project_is_enabled <- function(function_name = NULL) {
  if (is.null(function_name)) {
    function_name <- ""
  }
  if (is.null(enabled_project("project_path"))) {
    stop(paste("the function", function_name, ": can only work when a project is enabled."))
  }
}


# helpers to act on columns in a lapply function call
get_variable_names <- function(dataset) {
  list(names(dataset))
}

# this function contains heuristics to detect variables in rectangular datasets
# that are numeric but meant to be used as grouping factors for the data.
get_variable_class <- function(column) {
   unname(if(class(column) == "numeric"){
       # when it is numeric test if is a potential category
       if(isTRUE(all.equal(column, floor(column)))){
         # when it is a potential category apply a normality test
         # this however only works for reasonable sample size between 3 and 5000
         # when the sample size is larger we need to switch to anderson darling
         # or take only the first 5000 values as representatives (maybe sampling
         # would be better then)
         if(shapiro.test(column)$p.value < .01) {"character"} else {"numeric"}
       } else {
         "numeric"
       }
       # if it is then test if for normality
     } else {
       "character"
     })
}

get_variable_completeness <- function(dataset) {
  list(colSums(is.na(dataset)))
}

get_category_instances <- function(dataset) {
  lapply(dataset, function(column){ if(get_variable_class(column) == "character"){ unique(column) }
  })
}

# functions to coerce a call into a list to deconstruct
# functions passed into parameters of other functions
convert_call_to_list <- function(x) {
  if (is.call(x)) as.list(x) else x
}

convert_params_to_list <- function() {
  first_pass <- as.list(match.call())
  second_pass <- lapply(first_pass, convert_call_to_list)
  setNames(second_pass, names(first_pass))
  return(second_pass)
}

# A function to globally search and replace across files.
fix_factor_globally <- function(list_of_files = NULL, search_term, replace_term) {
  for (a_file in list_of_files) {
    lines_of_file <- readLines(a_file)
    substituted_lines_of_file <- gsub(pattern = paste0("\\b", search_term, "\\b"), replacement = replace_term, lines_of_file)
    cat(substituted_lines_of_file, file = a_file, sep = "\n")
  }
}

# get the system information for writing the correct csv file type with metadata
get_locale <- function() {
  switch(Sys.info()[["sysname"]],
    Windows = {
      if (grepl("German|de_DE", Sys.getlocale(category = "LC_ALL"))) {
        return("de")
      } else {
        return("other")
      }
    },
    Linux = {
      if (grepl("de_DE", Sys.getenv("LANG"))) {
        return("de")
      } else {
        return("other")
      }
    },
    Darwin = {
      # implement me
    }
  )
}

# if there is no data in the project we do not need to proceed
prepare_csv_data_metadata <- function(search_path = NULL) {
  csv_file_paths <- normalizePath(list.files(search_path, pattern = "*.(csv|tsv)$", ignore.case = TRUE, recursive = T, full.names = T))

  if (identical(csv_file_paths, character(0))) {
    stop("collect_csv_variables failed: There is no data in your folder")
  }

  all_file_paths <- dirname(csv_file_paths)
  all_file_names <- basename(csv_file_paths)
  all_file_names_without_extension <- tools::file_path_sans_ext(all_file_names)
  list_of_imported_data <- rio::import_list(csv_file_paths)
  repetition_pattern <- list(unlist(lapply(list_of_imported_data, length), recursive = T, use.names = F))
  file_id <- list(seq_along(all_file_paths))
  # file_id <- setNames(data.frame(unname(sapply(list_of_imported_data, identify_dataframe))), "file_id")
  all_variables_file_id <- data.frame(file_id = mapply(rep, file_id, repetition_pattern))

  # column_id_df = data.frame(column_id = unname(unlist(lapply(list_of_imported_data, function(dataset){
  # lapply(dataset, sha1)
  # }))))

  all_file_names_per_variable <- data.frame(file_name = mapply(rep, list(all_file_names), repetition_pattern))

  file_id_path_and_name <- data.frame(file_id = seq_along(all_file_paths), file_path = all_file_paths, file_name = all_file_names)

  all_variable_names <- lapply(list_of_imported_data, get_variable_names)
  names(all_variable_names) <- unlist(file_id_path_and_name["file_id"])

  all_variable_classes <- lapply(list_of_imported_data, function(dataset){
           list(unlist(lapply(dataset, get_variable_class), use.names = F))
  })

  # all_variable_classes <- lapply(list_of_imported_data, get_variable_class)
  names(all_variable_classes) <- unlist(file_id_path_and_name["file_id"])

  all_variable_completeness <- lapply(list_of_imported_data, get_variable_completeness)
  names(all_variable_completeness) <- unlist(file_id_path_and_name["file_id"])

  all_category_instances <- lapply(list_of_imported_data, get_category_instances)
  names(all_category_instances) <- unlist(file_id_path_and_name["file_id"])

  all_category_instances <-
    lapply(all_category_instances, function(element) {
      lapply(element, function(sub_element) {
        if (is.null(sub_element)) {
          NA_character_
        } else {
          paste0(sub_element, collapse = ",")
        }
      })
    })

  all_category_instances <- setNames(stack(all_category_instances)[2:1], c("id", "variable_category"))

  output <-
    data.frame(all_variables_file_id,
      file_name = all_file_names_per_variable,
      # column_id = column_id_df,
      variable_name = do.call("rbind.data.frame", all_variable_names)[[1]] ,
      variable_class = as.character(do.call("rbind.data.frame", all_variable_classes)[[1]]),
      missing_values = do.call("rbind.data.frame", all_variable_completeness)[[1]],
      variable_category = all_category_instances["variable_category"]
    )

  return(output)
}

# a function to identify data frames. This allows files to be referenced even
# if the user renames them. It returns a cryptographic hash that includes the
# header names the columns andn rows content.
identify_dataframe <- function(input) {
  hashes_of_column_names <- as.vector(unlist(lapply(names(input), sha1)))
  hash_sum_of_column_names <- sha1(names(input))
  hashes_of_columns <- unname(sapply(input, function(column) {
    sha1(column)
  }))
  hash_sum_of_columns <- sha1(hashes_of_columns)
  hashes_of_rows <- apply(input, 1, function(the_row) {
    sha1(the_row)
  })
  hash_sum_of_rows <- sha1(hashes_of_rows)
  sha1(c(hash_sum_of_column_names, hash_sum_of_columns, hash_sum_of_rows))
}
