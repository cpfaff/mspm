#' Collect all csv related metadata
#'
#' A thin wrapper around the collector for variables and categories
#'
#' @param ... Arguments passed into the functions to collect variables and
#'        categories from csv files.
#'
#' @examples
#' \dontrun{
#' collect_csv_metadata(...)
#' }
#' 
#' @return No value is returned; this function is called for its side effects.
#' @export collect_csv_metadata
#' @export update_csv_metadata
#'
collect_csv_metadata <- update_csv_metadata <- function(...) {
  collect_csv_variables(...)
  collect_csv_categories(...)
}

#' Collect all csv variables as metadata sheet
#'
#' The function collects all csv files variable names, their class and count of mising
#' values. It compiles a file in the
#' data.
#'
#' @param input_path A path to look for csv files. Defaults to the data
#'        folder of the active project.
#' @param output_path A path to save the collected metadata to.
#'        Defaults to the metadata folder of the active project.
#'
#' @examples
#' \dontrun{
#' collect_csv_variables(input_path = "~/test")
#' }
#' 
#' @return No value is returned; this function is called for its side effects.
#' @import dplyr
#' @importFrom rio import
#' @importFrom tidyr separate_rows
#' @importFrom fs file_exists
#' @importFrom utils install.packages installed.packages read.csv sessionInfo stack update.packages write.csv
#' @export collect_csv_variables

collect_csv_variables <- function(input_path = yspm::reference_content("data"), output_path = yspm::reference_content("metadata/dataset")) {
  check_if_project_is_enabled("collect_csv_variables")

  switch(Sys.info()[["sysname"]],
    Windows = {
      if (grepl("German|de_DE", Sys.getlocale(category = "LC_ALL"))) {
        locale <- "de"
      } else {
        locale <- "other"
      }
    },
    Linux = {
      if (grepl("de_DE", Sys.getenv("LANG"))) {
        locale <- "de"
      } else {
        locale <- "other"
      }
    },
    Darwin = {
      # implement me
    }
  )


  normalized_input_path <- suppressWarnings(normalizePath(path(input_path)))
  normalized_output_path <- suppressWarnings(normalizePath(path(output_path)))

  csv_file_paths <- normalizePath(list.files(normalized_input_path, pattern = "*.(csv|tsv)", ignore.case = TRUE, recursive = T, full.names = T))

  if (identical(csv_file_paths, character(0))) {
    stop("collect_csv_variables failed: There is no data in your folder")
  }

  all_file_paths <- dirname(csv_file_paths)
  all_file_names <- basename(csv_file_paths)
  all_file_names_without_extension <- tools::file_path_sans_ext(all_file_names)
  list_of_imported_data <- rio::import_list(csv_file_paths)
  repetition_pattern <- list(unlist(lapply(list_of_imported_data, length), recursive = T, use.names = F))
  file_id <- list(seq_along(all_file_paths))
  all_variables_file_id <- data.frame(file_id = mapply(rep, file_id, repetition_pattern))
  all_file_names_per_variable <- data.frame(file_name = mapply(rep, list(all_file_names), repetition_pattern))

  file_id_path_and_name <- data.frame(id = seq_along(all_file_paths), file_path = all_file_paths, file_name = all_file_names)

  all_variable_names <- lapply(list_of_imported_data, get_variable_names)
  names(all_variable_names) <- unlist(file_id_path_and_name["id"])

  all_variable_classes <- lapply(list_of_imported_data, get_variable_classes)
  names(all_variable_classes) <- unlist(file_id_path_and_name["id"])

  all_variable_completeness <- lapply(list_of_imported_data, get_variable_completeness)
  names(all_variable_completeness) <- unlist(file_id_path_and_name["id"])

  all_category_instances <- lapply(list_of_imported_data, get_category_instances)
  names(all_category_instances) <- unlist(file_id_path_and_name["id"])

  all_category_instances <-
    lapply(all_category_instances, function(element) {
      lapply(element, function(sub_element) {
        if (is.null(sub_element)) {
          NA
        } else {
          paste0(sub_element, collapse = ",")
        }
      })
    })

  all_category_instances <- setNames(stack(all_category_instances)[2:1], c("id", "variable_category"))

  output <-
    data.frame(all_variables_file_id,
      file_name = all_file_names_per_variable,
      variable_name = do.call("rbind.data.frame", all_variable_names)[[1]],
      variable_class = do.call("rbind.data.frame", all_variable_classes)[[1]],
      missing_values = do.call("rbind.data.frame", all_variable_completeness)[[1]],
      variable_category = all_category_instances["variable_category"]
    )

  output_with_variable_class <- base::transform(output, variable_unit = ifelse(variable_class == "character", NA, ""))

  additional_columns <- c("variable_description")
  output_with_variable_class[, additional_columns] <- c("")

  if (file_exists(paste0(path(normalized_output_path, "csv_variables.csv")))) {
    # when the file exists we need to preserve the information somehow in case
    # that somebody already started to fill out the metadata file. They would
    # be really mad if we overwrite it. ;-). We create a new table and then merge
    # with the existing one by the fingerprint. Afterwards we refingerprint the
    # new table.
    current_data <- subset(output_with_variable_class, select = -c(variable_unit, variable_description))
    csv_variable_metadata <- subset(read.csv(path(normalized_output_path, "csv_variables.csv"), row.names = NULL),
      select = c("variable_name", "variable_class", "variable_unit", "variable_description")
    )

    updated_csv_variable_metadata <- merge(x = current_data, y = csv_variable_metadata, by = c("variable_name", "variable_class"), all = TRUE)[, union(names(current_data), names(csv_variable_metadata))]

    # read the metadata information from before (however only preserve information for the merge
    csv_variable_metadata <- subset(read.csv(path(normalized_output_path, "csv_variables.csv"), row.names = NULL), select = -c(file_id, file_name, missing_values, variable_category))
    if (any(names(csv_variable_metadata) %in% "fix_variable")) {
      # it needs to find what to replace variable_category and replace_by fix_variable
      apply(
        csv_variable_metadata[!(is.na(csv_variable_metadata$fix_variable) | csv_variable_metadata$fix_variable == ""), ], 1,
        function(a_row) {
          old_term <- unname(unlist(a_row["variable_name"]))
          new_term <- unname(unlist(a_row["fix_variable"]))
          fix_factor_globally(list_of_files = csv_file_paths, search_term = old_term, replace_term = new_term)
        }
      )

      # when we do this we need to read the files again
      list_of_imported_data <- rio::import_list(csv_file_paths)
      repetition_pattern <- list(unlist(lapply(list_of_imported_data, length), recursive = T, use.names = F))
      file_id <- list(seq_along(all_file_paths))
      all_variables_file_id <- data.frame(file_id = mapply(rep, file_id, repetition_pattern))
      all_file_names_per_variable <- data.frame(file_name = mapply(rep, list(all_file_names), repetition_pattern))
      file_id_path_and_name <- data.frame(id = seq_along(all_file_paths), file_path = all_file_paths, file_name = all_file_names)
      all_variable_names <- lapply(list_of_imported_data, get_variable_names)
      names(all_variable_names) <- unlist(file_id_path_and_name["id"])

      all_category_instances <- lapply(list_of_imported_data, get_category_instances)
      names(all_category_instances) <- unlist(file_id_path_and_name["id"])

      all_category_instances <-
        lapply(all_category_instances, function(element) {
          lapply(element, function(sub_element) {
            if (is.null(sub_element)) {
              NA
            } else {
              paste0(sub_element, collapse = ",")
            }
          })
        })

      all_category_instances <-
        setNames(stack(all_category_instances)[2:1], c("id", "variable_category"))

      output <-
        data.frame(all_variables_file_id,
          file_name = all_file_names_per_variable,
          variable_name = do.call("rbind.data.frame", all_variable_names)[[1]],
          variable_class = do.call("rbind.data.frame", all_variable_classes)[[1]],
          missing_values = do.call("rbind.data.frame", all_variable_completeness)[[1]],
          variable_category = all_category_instances["variable_category"]
        )

      csv_variable_metadata$variable_name <- ifelse(csv_variable_metadata$fix_variable == "" | is.na(csv_variable_metadata$fix_variable),
        as.character(csv_variable_metadata$variable_name),
        as.character(csv_variable_metadata$fix_variable)
      )

      # then check for descriptions
      sorted_data <- csv_variable_metadata[with(csv_variable_metadata, order(variable_name, variable_class)), ]
      # for(i in 2:nrow(sorted_data)) if(!is.na(sorted_data$fix_variable[i]) | sorted_data$fix_variable[i] != "") sorted_data$variable_description[i] <- sorted_data$variable_description[i-1]
      csv_variable_metadata <- subset(unique(sorted_data), select = -c(fix_variable))
    }

    # return(list(names = union(names(output), names(csv_variable_metadata)), curr = output, metadata = csv_variable_metadata))
    updated_csv_variable_metadata <- merge(x = output, y = csv_variable_metadata, by = c("variable_name", "variable_class"), all = TRUE)
    # if categories have been removed we need to address this here and remove them from the metadata
    updated_csv_variable_metadata <- updated_csv_variable_metadata[!(is.na(updated_csv_variable_metadata$file_id) | is.na(updated_csv_variable_metadata$file_name)), ]
    if (locale == "de") {
      write.csv2(updated_csv_variable_metadata, paste0(path(normalized_output_path, "csv_variables.csv")), row.names = FALSE)
    } else {
      write.csv(updated_csv_variable_metadata, paste0(path(normalized_output_path, "csv_variables.csv")), row.names = FALSE)
    }
    if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
      message("File csv_variables.csv has been successfully updated.")
    }
  } else {
    if (locale == "de") {
      write.csv2(data.frame(output_with_variable_class),
        paste0(path(normalized_output_path, "csv_variables.csv")),
        row.names = F
      )
    } else {
      write.csv(data.frame(output_with_variable_class),
        paste0(path(normalized_output_path, "csv_variables.csv")),
        row.names = F
      )
    }

    if (file_exists(paste0(path(normalized_output_path, "csv_variables.csv")))) {
      message("File csv_variables.csv has been created successfully.")
    }
  }
}

#' Collect all csv file categories as metadata sheet.
#'
#' @param input_path A path to look for csv files. Defaults to the data
#'        folder of the active project.
#' @param output_path A path to save the collected metadata to.
#'        Defaults to the metadata folder of the active project.
#'
#' @examples
#' \dontrun{
#' collect_csv_categories(input_path = "~/test")
#' }
#' 
#' @return No value is returned; this function is called for its side effects.
#' @importFrom rio import
#' @importFrom tidyr separate_rows
#' @export collect_csv_categories

collect_csv_categories <- function(input_path = yspm::reference_content("data"), output_path = yspm::reference_content("metadata/dataset")) {
  check_if_project_is_enabled("collect_csv_categories")

  switch(Sys.info()[["sysname"]],
    Windows = {
      if (grepl("German|de_DE", Sys.getlocale(category = "LC_ALL"))) {
        locale <- "de"
      } else {
        locale <- "other"
      }
    },
    Linux = {
      if (grepl("de_DE", Sys.getenv("LANG"))) {
        locale <- "de"
      } else {
        locale <- "other"
      }
    },
    Darwin = {
      # implement me
    }
  )

  normalized_input_path <- suppressWarnings(normalizePath(path(input_path)))
  normalized_output_path <- suppressWarnings(normalizePath(path(output_path)))

  csv_file_paths <- normalizePath(list.files(normalized_input_path, pattern = "*.(csv|tsv)", ignore.case = TRUE, recursive = T, full.names = T))

  if (identical(csv_file_paths, character(0))) {
    stop("collect_csv_categories failed: There is no data in your folder")
  }

  all_file_paths <- dirname(csv_file_paths)
  all_file_names <- basename(csv_file_paths)
  all_file_names_without_extension <- tools::file_path_sans_ext(all_file_names)
  list_of_imported_data <- rio::import_list(csv_file_paths)
  repetition_pattern <- list(unlist(lapply(list_of_imported_data, length), recursive = T, use.names = F))
  file_id <- list(seq_along(all_file_paths))
  all_variables_file_id <- data.frame(file_id = mapply(rep, file_id, repetition_pattern))
  all_file_names_per_variable <- data.frame(file_name = mapply(rep, list(all_file_names), repetition_pattern))

  file_id_path_and_name <- data.frame(id = seq_along(all_file_paths), file_path = all_file_paths, file_name = all_file_names)

  all_variable_names <- lapply(list_of_imported_data, get_variable_names)
  names(all_variable_names) <- unlist(file_id_path_and_name["id"])

  all_category_instances <- lapply(list_of_imported_data, get_category_instances)
  names(all_category_instances) <- unlist(file_id_path_and_name["id"])

  all_category_instances <-
    lapply(all_category_instances, function(element) {
      lapply(element, function(sub_element) {
        if (is.null(sub_element)) {
          NA
        } else {
          paste0(sub_element, collapse = ",")
        }
      })
    })

  all_category_instances <-
    setNames(stack(all_category_instances)[2:1], c("id", "variable_category"))

  output <-
    data.frame(all_variables_file_id,
      file_name = all_file_names_per_variable,
      variable_name = do.call("rbind.data.frame", all_variable_names)[[1]],
      variable_category = all_category_instances["variable_category"]
    )

  output_separated <- tidyr::separate_rows(output, variable_category, sep = ",")

  additional_columns <- c("variable_description")
  output_separated[, additional_columns] <- c("")
  output_separated <- output_separated[!is.na(output_separated$variable_category), ]

  if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
    # when the file exists we need to preserve the information somehow in case
    # that somebody already started to fill out the metadata file. They would
    # be really mad if we overwrite it. ;-).

    # get the information from all csv files in the data folder
    current_data <- subset(output_separated, select = -c(variable_description))

    # read the metadata information from before (however only preserve information for the merge
    csv_category_metadata <- subset(read.csv(path(normalized_output_path, "csv_categories.csv"), row.names = NULL), select = -c(file_id, file_name))

    if (any(names(csv_category_metadata) %in% "fix_category")) {
      # it needs to find what to replace variable_category and replace_by fix_category
      apply(
        csv_category_metadata[!(is.na(csv_category_metadata$fix_category) | csv_category_metadata$fix_category == ""), ], 1,
        function(a_row) {
          old_term <- unname(unlist(a_row["variable_category"]))
          new_term <- unname(unlist(a_row["fix_category"]))
          fix_factor_globally(list_of_files = csv_file_paths, search_term = old_term, replace_term = new_term)
        }
      )

      # when we do this we need to read the files again
      list_of_imported_data <- rio::import_list(csv_file_paths)
      repetition_pattern <- list(unlist(lapply(list_of_imported_data, length), recursive = T, use.names = F))
      file_id <- list(seq_along(all_file_paths))
      all_variables_file_id <- data.frame(file_id = mapply(rep, file_id, repetition_pattern))
      all_file_names_per_variable <- data.frame(file_name = mapply(rep, list(all_file_names), repetition_pattern))
      file_id_path_and_name <- data.frame(id = seq_along(all_file_paths), file_path = all_file_paths, file_name = all_file_names)
      all_variable_names <- lapply(list_of_imported_data, get_variable_names)
      names(all_variable_names) <- unlist(file_id_path_and_name["id"])

      all_category_instances <- lapply(list_of_imported_data, get_category_instances)
      names(all_category_instances) <- unlist(file_id_path_and_name["id"])

      all_category_instances <-
        lapply(all_category_instances, function(element) {
          lapply(element, function(sub_element) {
            if (is.null(sub_element)) {
              NA
            } else {
              paste0(sub_element, collapse = ",")
            }
          })
        })

      all_category_instances <-
        setNames(stack(all_category_instances)[2:1], c("id", "variable_category"))

      output <-
        data.frame(all_variables_file_id,
          file_name = all_file_names_per_variable,
          variable_name = do.call("rbind.data.frame", all_variable_names)[[1]],
          variable_category = all_category_instances["variable_category"]
        )

      output_separated <- tidyr::separate_rows(output, variable_category, sep = ",")

      output_separated[, additional_columns] <- NA
      output_separated <- output_separated[!is.na(output_separated$variable_category), ]

      current_data <- subset(output_separated, select = -c(variable_description))

      # then fix the naming in the metadata
      csv_category_metadata$variable_category <- ifelse(csv_category_metadata$fix_category == "" | is.na(csv_category_metadata$fix_category),
        as.character(csv_category_metadata$variable_category),
        as.character(csv_category_metadata$fix_category)
      )
      # then check for descriptions
      sorted_data <- csv_category_metadata[with(csv_category_metadata, order(variable_name, variable_category)), ]
      # for(i in 2:nrow(sorted_data)) if(!is.na(sorted_data$fix_category[i]) | sorted_data$fix_category[i] != "") sorted_data$variable_description[i] <- sorted_data$variable_description[i-1]
      csv_category_metadata <- subset(unique(sorted_data), select = -c(fix_category))
    }

    updated_csv_category_metadata <- merge(x = current_data, y = csv_category_metadata, by = c("variable_name", "variable_category"), all = TRUE)[, union(names(current_data), names(csv_category_metadata))]

    # if categories have been removed we need to address this here and remove them from the metadata
    updated_csv_category_metadata <- updated_csv_category_metadata[!(is.na(updated_csv_category_metadata$file_id) | is.na(updated_csv_category_metadata$file_name)), ]

    if (locale == "de") {
      write.csv2(updated_csv_category_metadata, paste0(path(normalized_output_path, "csv_categories.csv")), row.names = FALSE)
    } else {
      write.csv(updated_csv_category_metadata, paste0(path(normalized_output_path, "csv_categories.csv")), row.names = FALSE)
    }

    if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
      message("File csv_categories.csv has been successfully updated.")
    }
  } else {
    if (locale == "de") {
      write.csv2(data.frame(output_separated),
        paste0(path(normalized_output_path, "csv_categories.csv")),
        row.names = F
      )
    } else {
      write.csv(data.frame(output_separated),
        paste0(path(normalized_output_path, "csv_categories.csv")),
        row.names = F
      )
    }

    if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
      message("File csv_categories.csv has been created successfully.")
    }
  }
}
