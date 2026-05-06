block()
  include("${CMAKE_CURRENT_LIST_DIR}/toolchain-config.cmake")
  set(vcpkg_path ${vcpkg_path} PARENT_SCOPE)
  set(llvm_mingw_root ${llvm_mingw_root} PARENT_SCOPE)
endblock()

# 先加載vcpkg的mingw工具鏈
include("${vcpkg_path}/scripts/toolchains/mingw.cmake")
unset(vcpkg_path)

set(VCPKG_C_COMPILER    "${llvm_mingw_root}/bin/clang.exe")
set(VCPKG_CXX_COMPILER  "${llvm_mingw_root}/bin/clang++.exe")
unset(llvm_mingw_bin)

set(CMAKE_C_COMPILER   "${VCPKG_C_COMPILER}")
set(CMAKE_CXX_COMPILER "${VCPKG_CXX_COMPILER}")

# Clang 必须加，否则链接巨慢
set(VCPKG_LINKER_FLAGS "-fuse-ld=lld")
