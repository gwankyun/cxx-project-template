param(
    [Parameter(Mandatory = $true)][ValidateSet('msvc', 'gcc', 'clang')][string]$compiler,
    [switch]$DebugMode
)

$cfg = @{
    msvc  = @{t = 'x64-windows'; r = 'vcpkg_installed_msvc' }
    gcc   = @{t = 'x64-mingw-dynamic'; r = 'vcpkg_installed_gcc' }
    clang = @{t = 'x64-llvm-mingw-dynamic'; r = 'vcpkg_installed_clang' }
}[$compiler]

vcpkg install "--triplet=$($cfg.t)" "--x-install-root=$($cfg.r)" $(if ($DebugMode) { '--debug' })
