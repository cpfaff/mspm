#' @importFrom parallel detectCores
.onLoad <- function(lib, pkg) {
  .yspm.env$.yspm.enabled_project <- list(
    project_path = NULL,
    project_checkpoint = NULL
  )

  .yspm.env$.yspm.project_structure <- list(
    folder_data = "project/data",
    folder_primary_data = "project/data/01_primary",
    folder_interim_data = "project/data/02_interim",
    folder_cleaned_data = "project/data/03_cleaned",
    folder_figure_external = "project/figure/external",
    folder_figure_scripted = "project/figure/scripted",
    folder_metadata_data = "project/metadata/dataset",
    folder_metadata_project = "project/metadata/project",
    file_metadata_checkpoint = "project/metadata/project/checkpoint.dcf",
    file_metadata_project = "project/metadata/project/project.dcf",
    file_metadata_license = "project/metadata/project/license.dcf",
    folder_report_presentation = "project/report/presentation",
    folder_report_publication = "project/report/publication",
    folder_report_qualification = "project/report/qualification",
    folder_source = "project/source",
    folder_source_library = "project/source/library",
    file_library_main = "project/source/library/01_lib_main.R",
    file_library_import_data = "project/source/library/02_lib_import_data.R",
    file_library_clean_data = "project/source/library/03_lib_clean_data.R",
    file_library_transform_data = "project/source/library/04_lib_transform_data.R",
    file_library_visualise_data = "project/source/library/05_lib_visualise_data.R",
    file_library_model_data = "project/source/library/06_lib_model_data.R",
    folder_source_workflow = "project/source/workflow",
    file_workflow_packages = "project/source/workflow/00_wf_load_packages.R",
    file_workflow_main = "project/source/workflow/01_wf_main_script.R",
    file_workflow_import_data = "project/source/workflow/02_wf_import_data.R",
    file_workflow_clean_data = "project/source/workflow/03_wf_clean_data.R",
    file_workflow_transform_data = "project/source/workflow/04_wf_transform_data.R",
    file_workflow_visualise_data = "project/source/workflow/05_wf_visualise_data.R",
    file_workflow_model_data = "project/source/workflow/06_wf_model_data.R"
  )

  # speed up the compilation of packages from source
  system_core_count <- detectCores()
  Sys.setenv(MAKEFLAGS = system_core_count)
}
