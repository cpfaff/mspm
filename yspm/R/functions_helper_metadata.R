#' Functions to read and write project metadata
#'
#' Two functions to read metadata from a dcf formated file into
#' a data frame and write from a data frame to a new project
#' metadata dcf file.
#'
#' @param file_path A file path to the dcf formated metadata
read_project_metadata <- function(file_path) {
  read.dcf(file_path, all = T, keep.white = NULL)
}

#' @param metadata A data frame with the project metadata read
#' from the dcf file of an active project
#' @param element_name The name of a field in the metadata
#' read from the dcf file of an active project
write_project_metadata <- function(metadata, file_path) {
  quiet(write.dcf(metadata, file = file_path, append = FALSE, keep.white = NULL))
}

#' Two functions to modify metadata from a project
#'
#' The metadata can be rad from a dcf file into a data frame. The two
#' functions below can be used to query the metadata and update it if
#' this is required.

#' @param metadata A data frame with the project metadata read
#' from the dcf file of an active project
#' @param element_name The name of a field in the metadata
#' read from the dcf file of an active project
get_project_metadata <- function(metadata, element_name) {
  return(metadata[, element_name])
}

#' @param old_metadata A data frame with the project metadata read
#' from the dcf file of an active project
#' @param new_metadata A data frame with the new metadata. This will
#' update existing fields in the metadata data frame and add new ones
#' that have been unkown
set_project_metadata <- function(old_metadata, new_metadata) {
  names_old_metadata <-
    names(old_metadata)

  names_new_metadata <-
    names(new_metadata)

  metadata_with_new_fields <-
    data.frame(old_metadata, new_metadata[which(!(names_new_metadata %in% names_old_metadata))])

  names_of_metadata_fields_to_update <- names(new_metadata[names_new_metadata %in% names_old_metadata])

  metadata_with_new_fields[names_of_metadata_fields_to_update] <- new_metadata[names_of_metadata_fields_to_update]

  return(metadata_with_new_fields)
}


# Converts a list into a DCF file.
#
# This function will take an R list and convert it to a
# dcf file.
#
# The contents of the DCF file are stored as character strings.
#
# @param filename Is a character vector specifying the DCF file to be
#   written.
#
# @return Nothing. The function is called for its side effects.
write_list_to_dcf <- function(list, filename) {
  database_input <- lapply(list, function(x) paste0(x, collapse = ","))
  quiet(write.dcf(database_input, filename))
}
