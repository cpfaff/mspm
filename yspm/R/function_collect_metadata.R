#' Collect information from csv files as metadata
#'
#' This function is a thin wrapper around two functions which serve as separate
#' metadata collectors for variables and for categories in csv files.
#'
#' @param ... The arguments are further passed into the functions which collect
#'        the variables and the categories from csv files. You can find the
#'        parameterse in their documentation.
#'
#' @seealso collect_csv_variables
#' @seealso collect_csv_categories
#'
#' @examples
#' \dontrun{
#' collect_csv_metadata(...)
#' }
#' 
#' @return No value is returned; this function is called for its side effects.
#'
#' @export collect_csv_metadata
#' @export update_csv_metadata
#
collect_csv_metadata <- update_csv_metadata <- function(...) {
  collect_csv_variables(...)
  collect_csv_categories(...)
}

#' Collect variables from csv files into a metadata sheet
#'
#' The function collects names of variables from all the datasets which are found
#' in the data folder inside of an enabled project. It also collects the class of
#' each variable and the count of mising values. It compiles a file in the folder
#' which contains the metadata. There a user can provide further inforamtion about
#' each column with a description or a unit if this is applicable. The function
#' can be called multiple times when the underlying data updates. It preserves
#' information which has been written by the user
#'
#' @param input_path A path used to a folder which is used to search for csv files
#'        in. The folder which you provide here is recursively searched through for
#'        files. The parameter defaults to the data folder of the active project.
#' @param output_path A path to a folder which is used to save the collected
#'        metadata to. This defaults to the metadata folder of the active project.
#'
#' @examples
#' \dontrun{
#' collect_csv_variables(input_path = "~/test")
#' }
#' 
#' @return No value is returned; this function is called for its side effects.
#'
#' @import dplyr
#' @importFrom rio import
#' @importFrom tidyr separate_rows
#' @importFrom fs file_exists
#' @importFrom utils install.packages installed.packages read.csv sessionInfo stack update.packages write.csv
#'
#' @export collect_csv_variables

collect_csv_variables <- function(input_path = yspm::reference_content("data"), output_path = yspm::reference_content("metadata/data")) {
  the_function <- match.call()[[1]]

  check_if_project_is_enabled(the_function)

  # in order to read and write the correct csv type for the metadata (very hacky)
  locale <- get_locale()

  # normalize the paths
  normalized_input_path <- suppressWarnings(normalizePath(path(input_path)))
  normalized_output_path <- suppressWarnings(normalizePath(path(output_path)))

  # read all the csv datasets and prepare them for metadata collection
  output_with_variable_class <-
    prepare_csv_data_metadata(search_path = normalized_input_path)

  output_with_variable_class <-
    base::transform(output_with_variable_class, variable_unit = ifelse(variable_class == "character", "NA", ""))

  output_with_variable_class <-
    output_with_variable_class[with(output_with_variable_class, order(file_id, file_name, variable_name)), ]

  # when the metadata file exists we need to preserve the information in case
  # that somebody already started to fill out the metadata file. They would
  # be really mad if we overwrite it. ;-). We create a new table and then merge
  # with the existing one.
  if (file_exists(paste0(path(normalized_output_path, "csv_variables.csv")))) {
    # get all current data to update the information in the metadata if needed
    current_metadata <- subset(output_with_variable_class, select = -c(variable_unit))

    # we read from the current metadata all information which is used to merge the datasets and the columns which
    # are filled out by the user, the rest is complemented from the data
    if (locale == "de") {
      csv_variable_metadata <- subset(read.csv2(path(normalized_output_path, "csv_variables.csv"), row.names = NULL, stringsAsFactors = F),
        select = c("file_id", "variable_name", "variable_class", "variable_unit", "variable_description", "variable_instrumentation")
      )
    } else {
      csv_variable_metadata <- subset(read.csv(path(normalized_output_path, "csv_variables.csv"), row.names = NULL, stringsAsFactors = F),
        select = c("file_id", "variable_name", "variable_class", "variable_unit", "variable_description", "variable_instrumentation")
      )
    }

    # afterwards we go on and update the current meta data with new information
    updated_csv_variable_metadata <-
      merge(
        x = current_metadata,
        y = csv_variable_metadata,
        by = c("file_id", "variable_name", "variable_class"), all = TRUE
      )[, union(names(current_metadata), names(csv_variable_metadata))]

    # when categories have been removed they are still sticking around in the metadata we need to address this here
    # and remove them
    updated_csv_variable_metadata_cleaned <-
      updated_csv_variable_metadata[!(is.na(updated_csv_variable_metadata$file_id) | is.na(updated_csv_variable_metadata$file_name)), ]

    # then we sort everything by file id and name
    updated_csv_variable_metadata_sorted <-
      updated_csv_variable_metadata_cleaned[with(updated_csv_variable_metadata_cleaned, order(file_id, file_name, variable_name)), ]

    # in order to make opening with excel possible without problems
    if (locale == "de") {
      write.csv2(updated_csv_variable_metadata_sorted, paste0(path(normalized_output_path, "csv_variables.csv")), row.names = FALSE)
    } else {
      write.csv(updated_csv_variable_metadata_sorted, paste0(path(normalized_output_path, "csv_variables.csv")), row.names = FALSE)
    }

    if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
      message("File csv_variables.csv has been successfully updated.")
    }
  } else {
    # when we write this for the first time then we add a description column
    additional_columns <- c("variable_description", "variable_instrumentation")
    output_with_variable_class[, additional_columns] <- c("")

    # in order to make opening with excel possible without the need to use an import
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

collect_csv_categories <- function(input_path = yspm::reference_content("data"), output_path = yspm::reference_content("metadata/data")) {
  check_if_project_is_enabled("collect_csv_categories")
  locale <- get_locale()

  normalized_input_path <- suppressWarnings(normalizePath(path(input_path)))
  normalized_output_path <- suppressWarnings(normalizePath(path(output_path)))

  csv_file_paths <- normalizePath(list.files(normalized_input_path, pattern = "*.(csv|tsv)$", ignore.case = TRUE, recursive = T, full.names = T))

  if (identical(csv_file_paths, character(0))) {
    stop("collect_csv_categories failed: There is no data in your folder")
  }

  # get all the raw data prepared for metadata collection
  output_with_variable_class <-
    prepare_csv_data_metadata(search_path = normalized_input_path)

  output_with_variable_class <-
    output_with_variable_class[with(output_with_variable_class, order(file_id, file_name, variable_name)), ]

  output_separated <-
    tidyr::separate_rows(output_with_variable_class, variable_category, sep = ",")

  # remove all variableswhich are not categorical as they are not going to be described here.
  current_metadata <- output_separated[!is.na(output_separated$variable_category), ]

  if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
    # when the file exists we need to preserve the information somehow in case
    # that somebody already started to fill out the metadata file. They would
    # be really mad if we overwrite it. ;-).

    # read the metadata information from before (however only preserve information for the merge
    if (locale == "de") {
      csv_category_metadata <-
        subset(read.csv2(path(normalized_output_path, "csv_categories.csv"), row.names = NULL), select = -c(file_name))
    } else {
      csv_category_metadata <-
        subset(read.csv(path(normalized_output_path, "csv_categories.csv"), row.names = NULL), select = -c(file_name))
    }

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
      output_with_variable_class <-
        prepare_csv_data_metadata(search_path = normalized_input_path)

      output_separated <-
        tidyr::separate_rows(output_with_variable_class, variable_category, sep = ",")

      # because we do not want non categorical variables bein in here
      current_metadata <-
        output_separated[!is.na(output_separated$variable_category), ]

      # then fix the naming in the metadata
      csv_category_metadata$variable_category <- ifelse(csv_category_metadata$fix_category == "" | is.na(csv_category_metadata$fix_category),
        as.character(csv_category_metadata$variable_category),
        as.character(csv_category_metadata$fix_category)
      )

      # then check for descriptions
      # sorted_data <- csv_category_metadata[with(csv_category_metadata, order(variable_name, variable_category)), ]
      csv_category_metadata <-
        subset(unique(csv_category_metadata), select = -c(fix_category))
    }

    updated_csv_category_metadata <-
      merge(x = current_metadata, y = csv_category_metadata, by = c(
        "file_id",
        "variable_name",
        "variable_category"
      ), all = TRUE)[, union(names(current_metadata), names(csv_category_metadata))]

    # if categories have been removed we need to address this here and remove them from the metadata
    updated_csv_category_metadata <-
      updated_csv_category_metadata[!(is.na(updated_csv_category_metadata$file_id) | is.na(updated_csv_category_metadata$file_name)), ]

    updated_csv_category_metadata_sorted <-
      updated_csv_category_metadata[with(updated_csv_category_metadata, order(file_id, file_name, variable_name)), ]

    updated_csv_category_metadata_sorted <-
      subset(updated_csv_category_metadata_sorted, select = -c(variable_class, missing_values))

    if (locale == "de") {
      write.csv2(updated_csv_category_metadata_sorted, paste0(path(normalized_output_path, "csv_categories.csv")), row.names = FALSE)
    } else {
      write.csv(updated_csv_category_metadata_sorted, paste0(path(normalized_output_path, "csv_categories.csv")), row.names = FALSE)
    }

    if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
      message("File csv_categories.csv has been successfully updated.")
    }
  } else {
    # when we write the whole thing for the first time add colum for the description
    current_metadata <- subset(current_metadata, select = -c(variable_class, missing_values))
    additional_columns <- c("variable_description", "variable_instrumentation")
    current_metadata[, additional_columns] <- c("")

    if (locale == "de") {
      write.csv2(data.frame(current_metadata),
        paste0(path(normalized_output_path, "csv_categories.csv")),
        row.names = F
      )
    } else {
      write.csv(data.frame(current_metadata),
        paste0(path(normalized_output_path, "csv_categories.csv")),
        row.names = F
      )
    }

    if (file_exists(paste0(path(normalized_output_path, "csv_categories.csv")))) {
      message("File csv_categories.csv has been created successfully.")
    }
  }
}
