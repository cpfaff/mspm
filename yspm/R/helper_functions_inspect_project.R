# helpers
get_index_of_main_script <- function(input){
  which(input == max(input))
}

get_index_of_disconnected_scripts <- function(input){
  which(input == 0)
}

name_list_elements_after_file_names <- function(a_list, the_names){
  setNames(a_list, the_names)
}

