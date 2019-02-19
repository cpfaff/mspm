# an internal function which supports the create_project function in writing
# the package management into the packages file

construct_file_packages <- function(project_path){

header = list("# This file is for the angement of the externally required packages and functions.",
              "# To ensure Simply place all your library() function calls here")

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
                         "RColorBrewer")

mandatory_packages = c("import", # for the package management
                       "devtools", # install from github
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
               file = path(project_path, mspm::project_structure("file_packages")),
               append = TRUE)
       }
      )

constructed_library_calls = lapply(mandatory_packages,
                                   function(package){
                                     paste0("library(",package, ")")
                                   }
                                  )

lapply(constructed_library_calls,
       function(a_mandatory_library){
         write(a_mandatory_library,
               file = path(project_path, mspm::project_structure("file_packages")),
               append = TRUE)
         }
      )

}
