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

#### From an r-script

After you have installed everything, you need to setup a location where all
your future R-projects will reside in. The `yspm` package assists you with this
task. It makes sense to put this folder inside your users directory somewhere.

```r
# syntax
yspm::setup(root_path = <a new folder which will contain all your projects>)

# example (on linux)
yspm::setup(root_path = "~/r_projects")
```

The function creates the folder of your choice and inside of it a new R file
called `manage_projects.R`. Using this file as basis you can now start managing
your projects inside the folder. The file has some example content which helps
you getting started. Open the file and make sure that you set the working
directory to the new projects folder when working.

```r
r_projects
└── manage_projects.R
```

#### From an R-studio

You can also use R-Studio to setup your new project management. Just click on

* File > New Project > New Directory


### Create a new project

From inside the `manage_projects.R` file we create a new project simply calling
the function below.

```r
create_project(project_name = compile_project_name(first_name = "Your first name",
					           last_name = "Your last name"))
```

It creates a new project folder in a location you desire. This location
defaults to the current working directory. If you set this correctly then the
new project will be created in your projects directory next to the
`manage_projects.R` file. While you can provide any project folder name we here
use a function to help us to compile consistent project names
`compile_project_name()`. It requires your first and lat name and automatically
prepends the creation date of the project which helps sorring when you have
many projects in that folder (The format is
`YYYY-MM-DD_your_first_name_your_last_name`).

Note. The process to create a new project may take a while as it installs an
independent R environment and packages into your new project. Afterwards you
can enable the new project by executing the function below.

```r
enable_project(root_folder = choose.dir(),
	       project_name = compile_project_name(first_name = "Your first name",
					           last_name = "Your last name"))
```

### Project structure

To get a better overview of the project folder structure a documentation of
of the folders and files is provided below.

NOTE: While you can name your files whatever you want it is recommended to
follow some naming conventions. You should only use small letters, no special
characters, no trailing and leading spaces and separate single words with an
understore (i.e. snake_case, e.g. raw_tree_data.csv). You should also carefully
select the names of files to best reflect their contents. I know this is hard,
but try it!

* full overview

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
stores all external and internal source code. If you install a package it goes
here. If you load a library it goes here. If you analyse data it goes here.

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
your scripts, write a function so you can reuse it across your project. These
functions go into the function folder. The separate files in here are prepended
with numbers for a logical ordering of tasks. The files are named after typical
stages of a scientific data analysis workflow. You can use the this to organize
your functions. Then you can source the files in each of the files in the
workflow folder where it is needed to use the functionality.

* source > library

```
2019-02-19_my_full_name
└── project
    └── source
        ├── library
        │   └── packages.R
```

The library contains your package management. In your analysis you will quickly
want to install R packages to use the functionality they are providing. After
enableling a project install them into the project with the
`install.packages()` function. Load them from the `packages.R` file with the
`library(<packagename>)` function. This file should be imported into the main
script in the workflow folder.

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
in here are prepended with numbers for an ordering. The files are named after
typical stages of a scientific data analysis. You can use the files to
organized your script. The `01_main.R` file as a special role. It orchestrates
your whole R project. It sources the the `packages.R` file as well as the
personal library of functions and the worlflow files if the script is spread
across multiple files. For this also convenient functions exists to help
you (e.g. `project_content()`).


### References

A typical problem which breaks code is using paths e.g. in setting the working
directory in the beginning of a script. This is likely only working for the
very environment and only for a short time. If your code is shared the
likelyhood of the `setwd()` working on another computer is 0%. Thus the `yspm`
provides a function to reference content in the project which will always work
when the tool is setup like explained above and a project is enabled. It works
similar like the `here` R package and constructs paths always from the top of
your active project. For example if the project `2019-02-19_my_full_name` is
activated from your `manage_projects.R` file then the function `reference_content()`
will use that folder as root to construct paths. As each project contains a
folder named `project` the function also adds `project` to the path for you.

Lets say we want to source one of the `02_import_data.R` file from the source
folder in the `01_main.R` file in the workflow folder to import the functions
into our workflow.

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

Then we add the following line to our `01_main.R` file

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

            ... file content ...

            source(project_content("source/function/02_import_data.R"))

            ...
```

Which turns into:

```r
source("2019-02-19_my_full_name/project/source/function/02_import_data.R"))
```
