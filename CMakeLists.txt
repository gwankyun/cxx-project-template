# cmake版本
cmake_minimum_required(VERSION 4.2)

include(CMakePrintHelpers)

cmake_print_variables(CMAKE_VERSION)
# cmake_print_variables(MINGW)
if(MINGW)
  message(STATUS "MINGW")
endif()

# 項目名
project(
  cxx_project_template
  # 以下屬性皆可選
  LANGUAGES CXX
  VERSION 0.1.0
  DESCRIPTION "vcpkg使用三編譯器"
)

cmake_print_variables(CMAKE_CXX_COMPILER_ID)
cmake_print_variables(CMAKE_CXX_COMPILER_FRONTEND_VARIANT)
cmake_print_variables(CMAKE_CXX_COMPILER_VERSION)

find_package(doctest CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(unofficial-whereami CONFIG REQUIRED)
find_package(boost_scope REQUIRED CONFIG)
find_package(quill CONFIG REQUIRED)

# 添加庫
add_subdirectory(compiler)

add_library(common INTERFACE)
target_sources(
  common
  INTERFACE
    FILE_SET HEADERS
      BASE_DIRS #
        src
      FILES #
        src/common.hpp
)
target_link_libraries(common INTERFACE unofficial::whereami::whereami)

# 添加可執行文件
add_executable(main)
target_sources(main PRIVATE src/main.cpp)
target_link_libraries(
  main
  PRIVATE #
    compiler
    quill::quill
    nlohmann_json::nlohmann_json
    Boost::scope
    common
)
target_compile_features(main PRIVATE cxx_std_23)

add_executable(tests)
target_sources(tests PRIVATE src/test.cpp)
target_link_libraries(
  tests
  PRIVATE
    compiler
    doctest::doctest
    nlohmann_json::nlohmann_json
    common
    Boost::scope
)
target_compile_features(tests PRIVATE cxx_std_23)

# 啟用測試
enable_testing()
include(doctest)

add_test(NAME main_tests COMMAND main)

doctest_discover_tests(tests)

set(exe_list main tests)

set(files "")

list(APPEND files "${CMAKE_SOURCE_DIR}/test.json")

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

foreach(exe IN LISTS exe_list)
  foreach(f IN LISTS files)
    add_custom_command(
      TARGET ${exe}
      POST_BUILD
      COMMAND
        ${CMAKE_COMMAND} -E copy_if_different "${f}" "$<TARGET_FILE_DIR:${exe}>"
      COMMENT "Copy ${f}"
    )
  endforeach()

  #[[
  add_custom_command(
    TARGET ${exe}
    POST_BUILD
    COMMAND
      ${CMAKE_COMMAND} -E copy_if_different "${CMAKE_SOURCE_DIR}/test.json"
      "$<TARGET_FILE_DIR:${exe}>"
    COMMENT "Copy test.json"
  )

  # 複製運行時文件
  if(
    (
      (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
      AND (CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
    )
    OR ((CMAKE_CXX_COMPILER_ID STREQUAL "GNU"))
  )
    set(dirs "${COMPILER_BIN}")
    cmake_path(NORMAL_PATH dirs)
    add_custom_command(
      TARGET ${exe}
      POST_BUILD
      COMMAND
        ${CMAKE_COMMAND}
        # gersemi: off
        -D apps="$<TARGET_FILE:${exe}>"
        -D dirs="${dirs}"
        # gersemi: on
        -P "${CMAKE_SOURCE_DIR}/cmake/bundle.cmake"
      COMMENT ""
    )
  endif()
  #]]
endforeach()
