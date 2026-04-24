# 複製 `path` 路徑下的 `libc++.dll` 和 `libunwind.dll` 到 `target` 生成文件同目錄
function(clang_copy_dll)
  cmake_parse_arguments(
    copy_dll_arg
    ""
    "PATH;TARGET"
    "FILES"
    ${ARGN}
  )

  set(path ${copy_dll_arg_PATH})
  set(target ${copy_dll_arg_TARGET})

  # 查找 libc++.dll 和 libunwind.dll
  set(bin_path "${path}")

  set(src_list ${copy_dll_arg_FILES})

  # gersemi: off
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND
      ${CMAKE_COMMAND}
      -D dll_list="${src_list}"
      -D dest_path=""$<TARGET_FILE_DIR:${target}>""
      -D bin_path="${bin_path}"
      -P "${CMAKE_SOURCE_DIR}/cmake/copy_dll.cmake"
    COMMENT ""
  )
  # gersemi: on
endfunction()
