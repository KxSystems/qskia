set -e
set -x

export PATH="${PWD}/deps/depot_tools:${PATH}"

echo $PATH

OS=$(uname -s)

if [ "$OS" == Darwin ]; then
    # Prevent GN from using GNU Binutils
    export PATH=$(echo "$PATH" | awk -v RS=: -v ORS=: '$0 != "/opt/homebrew/opt/binutils/bin"')
fi

cd deps/skia
export GIT_SYNC_DEPS_SKIP_EMSDK=1
python3 tools/git-sync-deps

if [ "$1" == "" ]; then
    CC=clang
    CXX=clang++
else
    CC=clang-$1
    CXX=clang++-$1
fi

if [ "$AR" == "" ]; then
    AR=ar
fi

if [ "$USE_SYS" == "" ]; then
    USE_SYS=false
fi

ARGS="cc=\"$CC\" cxx=\"$CXX\" "\
"ar=\"$AR\" "\
"extra_cflags_cc=[\"-std=c++17\" $EXTRA_CFLAGS] "\
'is_official_build=true '\
'skia_enable_discrete_gpu=false '\
'skia_enable_fontmgr_custom_empty=true '\
'skia_enable_ganesh=false '\
'skia_use_gl=false '\
'skia_use_x11=false '\
'skia_enable_pdf=false '\
'skia_use_expat=false '\
'skia_use_freetype=true '\
'skia_use_harfbuzz=false '\
'skia_use_icu=false '\
'skia_use_libjpeg_turbo_decode=false '\
'skia_use_libjpeg_turbo_encode=false '\
'skia_use_libwebp_decode=false '\
'skia_use_libwebp_encode=false '\
'skia_use_piex=false '\
'skia_use_dng_sdk=false '\
"skia_use_system_freetype2=$USE_SYS "\
"skia_use_system_libpng=$USE_SYS "\

SYS_ZLIB=$USE_SYS

if [ "$OS" == Darwin ]; then
    SYS_ZLIB=true
fi

ARGS=$ARGS"skia_use_system_zlib=$SYS_ZLIB"

if [[ ! "$TARGET_CPU" == "" ]]; then
    ARGS=$ARGS" target_cpu=\"$TARGET_CPU\""
fi

echo $ARGS

bin/gn gen out/Static --args="$ARGS"

#bin/gn args out/Static --list
#exit 0

if [[ ${SKIP_FETCH_NINJA:-false} == "false" ]]; then
    bin/fetch-ninja
fi

ninja -C out/Static skia
