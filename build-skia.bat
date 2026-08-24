@echo off
set VSYEAR=%1
if "%VSYEAR%"=="" set VSYEAR=2017

if "%USE_SYS%"=="" set USE_SYS=false

set PATH=%cd%\deps\depot_tools;%PATH%
call gclient
cd deps\skia
call python3 tools/git-sync-deps --no-emsdk
set MY_GN_ARGS=^
clang_win=\"C:\Program Files\LLVM\" ^
win_vc=\"C:\Program Files (x86)\Microsoft Visual Studio\%VSYEAR%\BuildTools\VC\" ^
extra_cflags=[ %EXTRA_CFLAGS% ] ^
is_official_build=true ^
skia_enable_discrete_gpu=false ^
skia_enable_fontmgr_custom_empty=true ^
skia_enable_ganesh=false ^
skia_use_gl=false ^
skia_enable_pdf=false ^
skia_use_expat=false ^
skia_use_freetype=true ^
skia_use_harfbuzz=false ^
skia_use_icu=false ^
skia_use_libjpeg_turbo_decode=false ^
skia_use_libjpeg_turbo_encode=false ^
skia_use_libwebp_decode=false ^
skia_use_libwebp_encode=false ^
skia_use_piex=false ^
skia_use_dng_sdk=false ^
skia_use_system_freetype2=%USE_SYS% ^
skia_use_system_libpng=%USE_SYS% ^
skia_use_system_zlib=%USE_SYS%

echo "%MY_GN_ARGS%"
REM goto :end

bin\gn gen out/Static --args="%MY_GN_ARGS%"
REM goto :end

REM bin\gn args out/Static --list > ../../debug-gn-args.txt
REM goto :end

call python3 bin\fetch-ninja

call ninja -C out/Static skia

:end
cd ..\..
