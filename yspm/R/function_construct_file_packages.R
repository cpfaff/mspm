# an internal function which supports the create_project function in writing
# the package management into the packages file

construct_file_packages <- function(project_path){

file_documentation = list("# This file is for the management of your required packages and functions.",
              "# Add all packages here into a library call call if you want to include all",
              "# of their function at once. This however is not so much recommended as you",
              "# will notice package conflicts rather sooner than later. A solution to the",
              "# problem is to only include the function you need. yspm installed the includ",
              "# package into your project environment. Thus you can import single functions",
              "# like so import::from(<package>, <function>) e.g. import::from('dplyr', 'filter')",
              "",
              "# packages")

lapply(file_documentation,
       function(one_line){
         write(one_line,
               file = path(project_path, yspm::project_structure("file_packages")),
               append = TRUE)
       }
      )

optional_packages = c("readr",
                      "preadxl",
                      "haven",
                      "httr",
                      "rvest",
                      "xml2",
                      "tidyr",
                      "purrr",
                      "dplyr",
                      "forcats",
                      "hms",
                      "lubridate",
                      "stringr",
                      "ggplot2",
                      "broom",
                      "modelr",
                      "RColorBrewer",
                      "import",
                      "devtools",
                      "drake", # for the workflow functionality
                      "tibble", # for better data frames
                      "magrittr"# for the pipe
                      )

constructed_library_calls =
  lapply(optional_packages,
         function(package){
           paste0("# ", "library(",package, ")")
         }
  )

lapply(constructed_library_calls,
       function(a_recommended_library){
         write(a_recommended_library,
               file = path(project_path, yspm::project_structure("file_packages")),
               append = TRUE)
       }
      )

}
