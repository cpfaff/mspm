# setup
require(fs)

# helper
create_new_test_project <- function(){
    test_project_folder = path("/tmp",random_string())
    test_project_first_name = path("first_name")
    test_project_last_name = path("last_name")
    # create project
    quiet(create_project(root_folder = test_project_folder,
                         compile_project_name(first_name = test_project_first_name, last_name = test_project_last_name)))

    return(path(test_project_folder,
                compile_project_name(first_name = test_project_first_name,
                                     last_name = test_project_last_name)))
}
