block()
  include("${CMAKE_CURRENT_LIST_DIR}/toolchain-config.cmake")
  set(vcpkg_path ${vcpkg_path} PARENT_SCOPE)
endblock()

# 加載現有三元組
include(${vcpkg_path}/triplets/community/x64-mingw-dynamic.cmake)

# 設置工具鏈文件路徑
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${vcpkg_path}/triplets/community/llvm-mingw.cmake")
unset(vcpkg_path)
