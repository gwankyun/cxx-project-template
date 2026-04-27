# message(STATUS "dll_list: ${dll_list}")
# message(STATUS "dest_path: ${dest_path}")
# message(STATUS "bin_path: ${bin_path}")

# string(REGEX MATCHALL "[^ ]+" list_res "${dll_list}")
string(REGEX REPLACE "^\\[==\\[(.*)\\]==\\]$" "\\1" src_files "${src_files}")

foreach(f IN LISTS src_files)
  message(STATUS "f: ${f}")

  cmake_path(GET f FILENAME app_name)
  # cmake_print_variables(app_n ame2)
  # message(STATUS "app_name2: ${app_name2}")

  cmake_path(SET dest NORMALIZE "${dest_dir}/${app_name}")

#   set(libcpp_dll "${bin_path}")
#   cmake_path(APPEND libcpp_dll ${f})

#   file(COPY_FILE ${libcpp_dll} ${dest_path}/${f} RESULT result ONLY_IF_DIFFERENT)
  file(COPY_FILE ${f} ${dest} RESULT result ONLY_IF_DIFFERENT)

endforeach()

