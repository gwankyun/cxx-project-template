message(STATUS "dll_list: ${dll_list}")
message(STATUS "dest_path: ${dest_path}")
message(STATUS "bin_path: ${bin_path}")

string(REGEX MATCHALL "[^ ]+" list_res "${dll_list}")

foreach(f IN LISTS list_res)
  message(STATUS "f: ${f}")

  set(libcpp_dll "${bin_path}")
  cmake_path(APPEND libcpp_dll ${f})

  file(COPY_FILE ${libcpp_dll} ${dest_path}/${f} RESULT result ONLY_IF_DIFFERENT)

endforeach()

