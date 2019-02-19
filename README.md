# My small project management

The repository provides a small R package which helps with project mangement.
It bundles ideas for reproducibility and good documentation of projects in a
predefined and well documented project strucutre.

## Install

### Prerequisites

In order to work with the tool you need to be able building R packages locally.
Thus you need to install:

* Windows:
	- https://cran.rstudio.com/bin/windows/Rtools/
	- https://miktex.org/download


### R packages

```r
install.packages("devtools")
require(devtools)
install_github("cpfaff/mspm", subdir = "mspm")
install_github("cpfaff/checkpoint", subdir = "mspm")
```


## Getting started

### Create a new project

```r
require(mspm)
create_project(root_folder = choose.dir(),
	       project_name = compile_project_name(first_name = "Your first name",
					           last_name = "Your last name"))
```

This may take a while as it installs an independent R enviroment and packages
into your new project. Afterwards you can enable the new project from outside
by executing

```r
require(mspm)
enable_project(project_path = <path_to_the_project_directory>)
```

This may take a while as it installs an independent R enviroment and packages
into your new project. Afterwards you can enable the new project from outside
by executing

### Project structure

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
            ├── 01_scratchpad.R
            ├── 02_import_data.R
            ├── 03_clean_data.R
            ├── 04_transform_data.R
            ├── 05_visualise_data.R
            └── 06_model_data.R
```
