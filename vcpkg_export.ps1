# export.ps1 - 统一的 vcpkg 导出脚本（简化版）
param(
    [Parameter(Mandatory=$true)][ValidateSet('msvc','gcc','clang')][string]$compiler,
    [switch]$DebugMode
)

# 使用字符串插值简化目录路径
vcpkg export --raw `
    "--x-install-root=vcpkg_installed_$compiler" `
    "--output=$compiler" `
    --output-dir=vcpkg_exported `
    $(if($DebugMode){'--debug'})
