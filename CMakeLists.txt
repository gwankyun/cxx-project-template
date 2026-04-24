# cmake版本
cmake_minimum_required(VERSION 4.3)

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

include(cmake/clang.cmake) # clang_copy_dll

# 使用 clang 編譯器
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  set(bin_path "$ENV{LLVM_MINGW_ROOT}")
  cmake_path(APPEND bin_path "bin")

  clang_copy_dll(
    PATH "${bin_path}"
    TARGET main
    FILES "libc++.dll" "libunwind.dll"
  )
endif()

# 使用 gcc 編譯器
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(bin_path "$ENV{MINGW_ROOT}")
  cmake_path(APPEND bin_path "bin")

  # 複製 libc++.dll 和 libunwind.dll 到構建目錄
  clang_copy_dll(
    PATH "${llvm_bin}"
    TARGET main
    FILES "libgcc_s_seh-1.dll" "libstdc++-6.dll" "libwinpthread-1.dll"
  )
endif()

# 啟用測試
enable_testing()
include(doctest)
doctest_discover_tests(tests)
