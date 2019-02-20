# Your small project management

This repository provides an R package which helps with project management in R.
It provides functions to create a predefined folder structure. It has the
primary goal to help you structure your projects while convenient functions
allow you creating self contained, shareable and reproducible code. For this
several nice tools (e.g. the checkpoint package, ProjectTemplate) and ideas
(like form the here package) which are floating around in the R community are
wrapped up into a streamlined solution.

## Installation

In order to work with the project management tool you need to be able building
R packages locally on your computer. This requires the installation of the GNU
software development tools which comprise a C/C++ compiler and LaTeX if you
want to be able building R manuals and vignettes. Below you can find links and
instructions for different operating systems.

* Windows:
    - https://cran.rstudio.com/bin/windows/Rtools/
    - https://miktex.org/download


* Mac OS X
    - https://itunes.apple.com/us/app/xcode/id497799835?mt=12
    - http://www.tug.org/mactex/downloading.html

* Linux
    - Well that highly depends on your Linux-Distribution. Check out the Wiki
      of your distribution or ask google.

The package can be installed from GitHub using the `devtools` package. It also
requires a modified version of the checkpoint package to be installed which is
is more adjustable in its behavior. Just follow the instructions below.

```r
install.packages("devtools")
require(devtools)
install_github("cpfaff/checkpoint")
install_github("cpfaff/yspm", subdir = "yspm")
```

## Getting started

### Setup

After you have installed everything, you need to setup a location where all
your future R-projects will reside in. The `yspm` package assists you with this
task. It makes sense to put this folder inside your users directory somewhere.

```r
# syntax
yspm::setup_project_managment(root_path = <a new folder which will contain all your projects>)

# example (on linux)
yspm::setup_project_managment(root_path = "~/r_projects")
```

The function creates the folder of your choice and inside of it a file called
`manage_projects.R`. From now on you can manage your projects from this file.
Make sure that you set the working directory to the new projects folder when
working within the `manage_projects.R` file. It also contains some boilerplate
code and examples to get you started.

### Create a new project

From now on for project management related tasks, we are working inside the
`manage_projects.R` file. To create a new project simply add the function below
and call it.

```r
create_project(root_folder = choose.dir(),
	       project_name = compile_project_name(first_name = "Your first name",
					           last_name = "Your last name"))
```

The function creates a new project folder structure in the `root_folder` which
defaults to the current working directory and with this to your projects
folder. You should place your projects in a path where you store all your R
projects. You can provide your project name manually, however here a convenient
function is used which compiles a project name from the information given
(`YYYY-MM-DD_your_first_name_your_last_name`).

Note. The process to create a new project may take a while as it installs an
independent R environment and packages into your new project. Afterwards you
can enable the new project from outside by executing the function below.

```r
enable_project(root_folder = choose.dir(),
	       project_name = compile_project_name(first_name = "Your first name",
					           last_name = "Your last name"))
```

### Project structure

Below you find an overview about the overall folder structure and a
documentation of the structure and contents.

NOTE: All files that you place somewhere in the structure should be named in
snake case. This means separate single words with an underscore (e.g.
`snake_case.R`, `raw_tree_data.csv`). You should also carefully select the
names of files to best reflect their contents. I know this is hard, but try!

* Full overview

```
2019-02-19_my_full_name
└── project
    ├── data
    │   ├── 01_primary
    │   ├── 02_interim
    │   └── 03_cleaned
    ├── figure
    │   ├── external
    │   └── scripted
    ├── metadata
    │   ├── dataset
    │   └── package
    │       ├── author.dcf
    │       └── checkpoint.dcf
    ├── report
    │   ├── presentation
    │   ├── publication
    │   └── qualification
    └── source
        ├── function
        │   ├── 01_main.R
        │   ├── 02_import_data.R
        │   ├── 03_clean_data.R
        │   ├── 04_transform_data.R
        │   ├── 05_visualise_data.R
        │   └── 06_model_data.R
        ├── library
        │   └── packages.R
        └── workflow
            ├── 01_main.R
            ├── 02_import_data.R
            ├── 03_clean_data.R
            ├── 04_transform_data.R
            ├── 05_visualise_data.R
            └── 06_model_data.R
```

* data

```
2019-02-19_my_full_name
└── project
    ├── data
    │   ├── 01_primary
    │   ├── 02_interim
    │   └── 03_cleaned
```

The data folder is separated into three sub-folders which are prepended with
numbers for a fixed order.

1. Primary data

It stores primary data of your research. Non of your R scripts should write
here.

2. Interim data

Transformed, filtered, merged data products which are important for the
analysis or the results.

3. Cleaned

Cleaned primary data which is used e.g. in modelling, plotting.


* figure

```
2019-02-19_my_full_name
└── project
    ├── figure
    │   ├── external
    │   └── scripted

```

The figure folder is divided in two sub-folders.

1. external

Place all figures in here which have not been generated by R itself and are
essential for the report part of your project.

2. scripted

This folder stores figures crated by your R script.


* metadata

```
2019-02-19_my_full_name
└── project
    ├── metadata
    │   ├── dataset
    │   └── package
    │       ├── author.dcf
    │       └── checkpoint.dcf
```

The metadata folder is divided into two sub-folders which store

1. dataset

Information about the datasets in your project. You can use the function XXX to
collect information about your datasets and place it here in a format that you
can complement with metadata.

2. package

The package folder contains information about the project like the author of
the project and the checkpoint which is for now the date of project creation.
The files in here are in Debian control file format (dcf). It is natively
supported by the R environment and used in many places like e.g. the
description file in R packages.

* report

```
2019-02-19_my_full_name
└── project
    ├── report
    │   ├── presentation
    │   ├── publication
    │   └── qualification

```

The report folder is separated into three sub-folders which are pretty much
self explaining. Put your presentations or publications which are related to
this project into the respective folders. In case the project is qualification
work put the document into that folder.

* source

```
2019-02-19_my_full_name
└── project
    └── source
        ├── function
        │   ├── 01_main.R
        │   ├── 02_import_data.R
        │   ├── 03_clean_data.R
        │   ├── 04_transform_data.R
        │   ├── 05_visualise_data.R
        │   └── 06_model_data.R
        ├── library
        │   └── packages.R
        └── workflow
            ├── 01_main.R
            ├── 02_import_data.R
            ├── 03_clean_data.R
            ├── 04_transform_data.R
            ├── 05_visualise_data.R
            └── 06_model_data.R
```

The source folder is separated into three sub-folders. It is the place which
stores all external and internal source code. If you include a package it goes
here.

* source > function

```
2019-02-19_my_full_name
└── project
    └── source
        ├── function
        │   ├── 01_main.R
        │   ├── 02_import_data.R
        │   ├── 03_clean_data.R
        │   ├── 04_transform_data.R
        │   ├── 05_visualise_data.R
        │   └── 06_model_data.R
```

As a rule of thumb. When you have to copy and paste code more than 2 times in
your scripts, write a function from that code so that you can reuse it across
your project. These functions go into the function folder. The separate files
in here are prepended with numbers for an ordering. The files are further named
after typical stages of a scientific data analysis. You can use the files to
organized your functions.

* source > library

```
2019-02-19_my_full_name
└── project
    └── source
        ├── library
        │   └── packages.R
```

The library contains your package management. In your analysis you will quickly
want to install the first R packages. Mention them in here and import that file
in the main script in the workflow folder. This folder is also the place where
the R packages are installed when you have used the `enable_project()`
function.

* source > workflow


```
2019-02-19_my_full_name
└── project
    └── source
        └── workflow
            ├── 01_main.R
            ├── 02_import_data.R
            ├── 03_clean_data.R
            ├── 04_transform_data.R
            ├── 05_visualise_data.R
            └── 06_model_data.R
```

The workflow folder contains your complete analysis script. The separate files
in here are prepended with numbers for an ordering. The files are further named
after typical stages of a scientific data analysis. You can use the files to
organized your script.
