include(${CMAKE_CURRENT_LIST_DIR}/x64-mingw-dynamic.cmake)

set(VCPKG_ENV_PASSTHROUGH_UNTRACKED "LLVM_MINGW_ROOT")

set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/../../scripts/toolchains/llvm-mingw.cmake")
