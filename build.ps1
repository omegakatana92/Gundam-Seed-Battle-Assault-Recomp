$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$cmake = Get-Command cmake.exe -ErrorAction SilentlyContinue
$ninja = Get-Command ninja.exe -ErrorAction SilentlyContinue
$gcc = Get-Command gcc.exe -ErrorAction SilentlyContinue
$gxx = Get-Command g++.exe -ErrorAction SilentlyContinue
$cmakeSource = if ($cmake) { $cmake.Source.Replace("\", "/") }

# MSYS/Cygwin CMake rewrites Windows paths passed by PowerShell. Prefer a
# native CMake, including the copy bundled with Visual Studio.
if ($cmake -and $cmakeSource -notmatch "/(msys[^/]*|cygwin[^/]*)/" -and
    $cmakeSource -notmatch "/Git/usr/bin/") {
    $cmakePath = $cmake.Source
} else {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path -LiteralPath $vswhere) {
        $cmakePath = & $vswhere -latest -products * `
            -find "Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" |
            Select-Object -First 1
    }
}

if (-not $cmakePath) {
    throw "Native Windows CMake 3.20+ was not found. Install CMake or the Visual Studio C++ CMake tools, then run this script again."
}

$runtime = (Resolve-Path (Join-Path $root "../gbarecomp") -ErrorAction Stop).Path
$toml = (Resolve-Path (Join-Path $root "../tomlplusplus/include/toml++") -ErrorAction SilentlyContinue)
$build = Join-Path $root $(if ($ninja -and $gcc -and $gxx) { "build-ninja" } else { "build-msvc" })
$compilerBin = if ($gxx) { Split-Path $gxx.Source -Parent }
$bios = Join-Path $env:USERPROFILE "Downloads/build-ninja/gba_bios.bin"
$configureArgs = @("-S", $root, "-B", $build, "-DGBARECOMP_ROOT=$runtime")
if ($toml) {
    $configureArgs += "-DGBARECOMP_TOMLPP_INCLUDE_DIR=$($toml.Path)"
}
if (Test-Path -LiteralPath $bios) {
    $configureArgs += "-DGEMINI_BIOS_PATH=$bios"
}
if ($ninja -and $gcc -and $gxx) {
    $configureArgs += @("-G", "Ninja",
        "-DCMAKE_C_COMPILER=$($gcc.Source)",
    "-DCMAKE_CXX_COMPILER=$($gxx.Source)",
    "-DGBARECOMP_MINGW_RUNTIME_BIN=$compilerBin")
}
$previousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
& $cmakePath @configureArgs 2>&1
$configureStatus = $LASTEXITCODE
& $cmakePath --build $build --config Release --parallel 2>&1
$buildStatus = $LASTEXITCODE
$ErrorActionPreference = $previousErrorActionPreference
if ($configureStatus -ne 0) {
    throw "CMake configuration failed with exit code $configureStatus."
}
if ($buildStatus -ne 0) {
    throw "CMake build failed with exit code $buildStatus."
}
