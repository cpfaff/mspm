% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/function_inspect_project.R
\name{detect_unused_scripts}
\alias{detect_unused_scripts}
\title{Detect scripts which are not interlinked with other scripts}
\usage{

  detect_unused_scripts(path = yspm::project_structure("folder_source_workflow"))
}
\arguments{
\item{path}{A path to the folder to search for the main script in. This defaults
to the workflow folder of the project.}
}
\value{
The function returns a string with the names script files which are not
        mentioned by others.
}
\description{
It collects all script files in the scource directory and check if the are
referencing each other. It returns the names of the scripts which are not
mentioned by other scripts. They are either unused scripts in the project, or
the exist for a a specific purpose. However, we cannot guess their function
and the order of execution to make the whole project work is unclear.
}
