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
#' collect_csv_variables()
#' }
#'
#' @return No value is returned; this function is called for its side effects.
#' @importFrom rio import
#' @importFrom tidyr separate_rows
#' @importFrom fs file_exists
#' @export collect_csv_variables

collect_csv_variables <- function(input_path = yspm::reference_content("data"), output_path = yspm::reference_content("metadata/dataset")) {
  check_if_project_is_enabled("collect_csv_variables")

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
  output_with_variable_class[, additional_columns] <- NA
  write.csv(output_with_variable_class, paste0(path(normalized_output_path, "csv_variables.csv")), row.names = F)
  if (file_exists(paste0(path(normalized_output_path, "csv_variables.csv")))) {
    message("File csv_variables.csv has been created successfully.")
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
#' collect_csv_variables()
#' }
#'
#' @return No value is returned; this function is called for its side effects.
#' @importFrom rio import
#' @importFrom tidyr separate_rows
#' @export collect_csv_categories

collect_csv_categories <- function(input_path = yspm::reference_content("data"), output_path = yspm::reference_content("metadata/dataset")) {
  check_if_project_is_enabled("collect_csv_categories")

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
  output_separated[, additional_columns] <- NA
  write.csv(output_separated[!is.na(output_separated$variable_category), ], paste0(path(normalized_output_path, "csv_categories.csv")), row.names = F)
  if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
    message("File csv_categories.csv has been created successfully.")
  }
}
