# an internal function which supports the create_project function in writing
# the package management into the packages file

construct_file_packages <- function(project_path) {
  file_documentation <- list(
    "# This file is for the management of your required packages and functions.",
    "# Add all packages here into a library call call if you want to include all",
    "# of their function at once. This however is not so much recommended as you",
    "# will notice package conflicts rather sooner than later. A solution to the",
    "# problem is to only include the function you need. yspm installed the includ",
    "# package into your project environment. Thus you can import single functions",
    "# like so import::from(<package>, <function>) e.g. import::from('dplyr', 'filter')",
    "",
    "# packages:"
  )

  lapply(
    file_documentation,
    function(one_line) {
      write(one_line,
        file = path(project_path, yspm::project_structure("file_workflow_packages")),
        append = TRUE
      )
    }
  )

  optional_packages <- c(
    "readr", # fast reading of rectangular data
    "tibble", # a new take on data frames
    "tidyr", # tidy your data
    "dplyr", # split apply combine
    "purrr", # map functions on your data
    "forcats", # better handling of categories (e.g. keeping the order or sorting)
    "lubridate", # better handling of dates
    "hms", # handling time
    "stringr", # string manipulation framework
    "ggplot2", # plotting framework
    "broom", # cleaning messy output of r functions into tidy data frames.
    "modelr", # helpers for modelling data
    "drake", # a workflow tool for R
    "import", # selectively import functions of other packages into your workspace
    "readxl", # read excel data sheets
    "haven", # Import foreign statistical formats into R (spss, stata, sas)
    "httr", # Interact with web pages.
    "rvest", # web scraping tools
    "xml2", # read and write xml files
    "RColorBrewer", # a diverse color palette
    "devtools", # developing packages made easy
    "rio" # a general purpose input output package (reads, writes, converts everything)
  )

  package_description <- (c(
    "# The goal of 'readr' is to provide a fast and friendly way to read rectangular
  # data (like 'csv', 'tsv', and 'fwf'). It is designed to flexibly parse many
  # types of data found in the wild, while still cleanly failing when data
  # unexpectedly changes.",
    "# Tibbles are a new take on data frames in R. They dropped what is useless and
  # kept what is good with data frames.",
    "# Tidyr is an evolution of 'reshape2'. It's designed specifically for data tidying
  (not general reshaping or aggregating) and works well with 'dplyr' data
  pipelines.",
    "dplyr is A fast, consistent tool for working with data frame like objects, both in
  memory and out of memory."
  ))

  constructed_library_calls <-
    lapply(
      optional_packages,
      function(package) {
        paste0("# ", "library(", package, ")")
      }
    )

  lapply(
    constructed_library_calls,
    function(a_recommended_library) {
      write(a_recommended_library,
        file = path(project_path, yspm::project_structure("file_workflow_packages")),
        append = TRUE
      )
    }
  )
}

content_setup_manage_projects <- '# In this file you will manage all your future R projects.
# Below you can find some example code to get you started.

# Before you go on please make sure that your working directory is set to the
# directory of this project management file. .

# check that we are here
getwd()

# if we are not in the right directory set it now
# setdw(<your projects directory>)

# load the project mangement package
library(yspm)

# create a new project
# 
# as you can see the project name is compiled from a built in constructor
# function called compile_project_name. You can also build your own constructor
# functions. In that way you can name your projects whatever you want and ensure
# consistency in the naming.

create_project(project_name = compile_project_name(first_name = "Max",
                                                   last_name = "Mustermann",
                                                   project_category = "PhD"))

# enable a project
#
# When you enable your project you can use the constructor as well. 

# enable_project(project_name = compile_project_name(first_name = "Max",
                                                   # last_name = "Mustermann",
                                                   # project_category = "PhD"))

# Or you can provide the name of the folder manually

enable_project(project_path = "<date>_max_mustermann_phd")

# which project is enabled at the moment you can find out with
enabled_project()

# When you enabled a project you can inspect the project contents
show_content()

# Sharing of code is often a problem as the scripts contain paths to 
# files and folders which are only working on one system. Thus you can
# use a helper function provided by yspm to create stable and generic 
# references to yourfiles and folders.

reference_content("source/library/01_packages.R")

# Adhering to some rules for styling the source code of your R projects can
# increase the readability significantly. While learning some style does not
# hurt your can also use the function below which will format your files
# according to the tidyverse style guide (which is an extended version of the
# google style guide for R)

standardize_project_code()

# When you finished your project you should start documenting your data. The
# example below creates some dummy content to show you how yspm helps you with
# documenting your data.

# create example content to collect metadata
# require(tibble)
# require(readr)
# require(magrittr)

# add example content
# mtcars %>% tibble::rownames_to_column("car_name") %>% readr::write_csv(reference_content("data/01_primary/mtcars.csv"))
# iris %>% readr::write_csv(reference_content("data/01_primary/iris.csv"))

# collect metadata
#
collect_csv_metadata()
# you can also use the alias below
# update_csv_metadata()

# This function crates two new files. One for the variables of your datasets and one for the categories. 
# You can find the files located in the metadata folder of your project. There you can edit them to add
# descriptions for variables and categories as well as units. If you call the function again the metadata
# will be updated based on your current data (content that you already described will be preserved). There
# is also a synonymous function called update_csv_metadata() for a better readability of your code if you
# wish.

# During an analysis often data products need to be saved. The `yspm` package
# provides convenient constructors functions which help to compile consisten
# names for the content in your project folder structure.

# for example for plots:
compile_plot_filename(name = "01I-am-not sure what I amDoing", ext = "PNG")
'
