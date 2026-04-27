# 複製 `path` 路徑下的 `libc++.dll` 和 `libunwind.dll` 到 `target` 生成文件同目錄
function(target_copy_files)
  cmake_parse_arguments(
    copy_dll_arg # 前綴
    "" # 選項值
    # "PATH;TARGET" # 單值
    "TARGET" # 單值
    "FILES" # 多值
    ${ARGN}
  )

  # set(path ${copy_dll_arg_PATH})
  set(target ${copy_dll_arg_TARGET})
  set(files ${copy_dll_arg_FILES})

  # message(STATUS "path: ${path}")
  message(STATUS "target: ${target}")
  message(STATUS "files: ${files}")

  # gersemi: off
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND
      ${CMAKE_COMMAND}
      # -D dll_list=${files}
      -D src_files=[==[${files}]==]
      -D dest_dir=""$<TARGET_FILE_DIR:${target}>""
      # -D source="${path}"
      -P "${CMAKE_SOURCE_DIR}/cmake/copy_dll.cmake"
    COMMENT ""
  )
  # gersemi: on
endfunction()
