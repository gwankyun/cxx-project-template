# cmake版本
cmake_minimum_required(VERSION 4.2)

include(CMakePrintHelpers)

cmake_print_variables(CMAKE_VERSION)

# 項目名
project(
  cxx_project_templat
  # 以下屬性皆可選
  LANGUAGES
    CXX # 指定C++可以跳過C編譯器檢測
  VERSION
    0.1.0 # 版本
  DESCRIPTION "vcpkg使用三編譯器"
)

cmake_print_variables(CMAKE_CXX_COMPILER_ID)
cmake_print_variables(CMAKE_CXX_COMPILER_VERSION)

find_package(spdlog CONFIG REQUIRED)
find_package(doctest CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)

# 添加庫
add_subdirectory(compiler)

# 添加可執行文件
add_executable(main)
target_sources(
  main
  PRIVATE #
    src/main.cpp
)
target_link_libraries(
  main
  PRIVATE #
    compiler
    spdlog::spdlog
)
target_compile_features(main PRIVATE cxx_std_23)

add_executable(tests)
target_sources(
  tests
  PRIVATE #
    src/test.cpp
)
target_link_libraries(
  tests
  PRIVATE #
    compiler
    doctest::doctest
)
target_compile_features(tests PRIVATE cxx_std_23)

include(cmake/target_copy_files.cmake) # target_copy_files

# 使用 clang 編譯器()
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  cmake_path(SET clang_bin NORMALIZE "$ENV{LLVM_MINGW_ROOT}/bin")

  set(dll_files "${clang_bin}/libc++.dll" "${clang_bin}/libunwind.dll")

  target_copy_files(
    TARGET main
    FILES "${dll_files}"
  )
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

  target_copy_files(
    TARGET main
    FILES "${dll_files}"
  )
endif()

# 啟用測試
enable_testing()
include(doctest)
doctest_discover_tests(tests)
