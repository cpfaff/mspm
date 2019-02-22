#' @importFrom parallel detectCores
.onLoad <- function(lib, pkg) {
  .yspm.env$.yspm.enabled_project <- list(
    project_path = NULL,
    project_checkpoint = NULL
  )

  .yspm.env$.yspm.project_structure <- list(
    folder_primary_data = "project/data/01_primary",
    folder_interim_data = "project/data/02_interim",
    folder_cleaned_data = "project/data/03_cleaned",
    folder_figure_external = "project/figure/external",
    folder_figure_scripted = "project/figure/scripted",
    folder_metadata_dataset = "project/metadata/dataset",
    folder_metadata_package = "project/metadata/package",
    file_metadata_checkpoint = "project/metadata/package/checkpoint.dcf",
    file_metadata_author = "project/metadata/package/author.dcf",
    file_metadata_license = "project/metadata/package/author.dcf",
    folder_report_presentation = "project/report/presentation",
    folder_report_publication = "project/report/publication",
    folder_report_qualification = "project/report/qualification",
    folder_source_library = "project/source/library",
    file_library_packages = "project/source/library/01_packages.R",
    file_library_main = "project/source/library/02_main.R",
    file_library_import_data = "project/source/library/03_import_data.R",
    file_library_clean_data = "project/source/library/04_clean_data.R",
    file_library_transform_data = "project/source/library/05_transform_data.R",
    file_library_visualise_data = "project/source/library/06_visualise_data.R",
    file_library_model_data = "project/source/library/07_model_data.R",
    folder_source_workflow = "project/source/workflow",
    file_workflow_main = "project/source/workflow/01_main.R",
    file_workflow_import_data = "project/source/workflow/02_import_data.R",
    file_workflow_clean_data = "project/source/workflow/03_clean_data.R",
    file_workflow_transform_data = "project/source/workflow/04_transform_data.R",
    file_workflow_visualise_data = "project/source/workflow/05_visualise_data.R",
    file_workflow_model_data = "project/source/workflow/06_model_data.R"
  )

  # speed up the compilation of packages from source
  system_core_count <- detectCores()
  Sys.setenv(MAKEFLAGS = system_core_count)
}
