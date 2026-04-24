set(compiler_info_h "${CMAKE_BINARY_DIR}/compiler_info.h")

# gersemi: off
configure_file(
  src/compiler_info.h.in # 輸入模板文件
  "${compiler_info_h}"   # 輸出文件
  @ONLY                  # 衹替換 @VAR@ 形式的變量
)
# gersemi: on

# 添加庫
add_library(compiler)
target_sources(
  compiler
  PUBLIC
    FILE_SET compiler_header
      BASE_DIRS #
        src
      TYPE
        HEADERS #
      FILES #
        src/compiler.h
  PRIVATE
    src/compiler.cpp # 模塊實現單元
  PRIVATE
    FILE_SET HEADERS
      BASE_DIRS #
        ${CMAKE_BINARY_DIR}
      FILES #
        "${compiler_info_h}"
)
target_compile_features(compiler PRIVATE cxx_std_23)
