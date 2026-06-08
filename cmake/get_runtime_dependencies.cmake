function(get_runtime_dependencies out_var)
  set(files "")
  if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
    # 使用 clang 編譯器()
    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
      cmake_path(SET clang_bin NORMALIZE "$ENV{LLVM_MINGW_ROOT}/bin")

      set(dll_files "${clang_bin}/libc++.dll" "${clang_bin}/libunwind.dll")

      list(APPEND files "${dll_files}")
    endif()

    # 使用 gcc 編譯器
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      cmake_path(SET gcc_bin NORMALIZE "$ENV{MINGW64_ROOT}/bin")

      set(
        dll_files
        "${gcc_bin}/libgcc_s_seh-1.dll"
        "${gcc_bin}/libstdc++-6.dll"
        "${gcc_bin}/libwinpthread-1.dll"
      )

      list(APPEND files "${dll_files}")
    endif()
  endif()

  set("${out_var}" "${result}" PARENT_SCOPE)
endfunction()
