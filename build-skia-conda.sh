OS=$(uname -s)

if [ "$OS" == Linux ]; then
    export CONDA_BUILD_SYSROOT="$CONDA_PREFIX/$(uname -m)-conda-linux-gnu/sysroot"
    export AR="$CONDA_PREFIX/bin/$(uname -m)-conda-linux-gnu-ar"
fi

export USE_SYS=true
export SKIP_FETCH_NINJA=true
export EXTRA_CFLAGS=,"\"-I$CONDA_PREFIX/include/freetype2\"","\"-I$CONDA_PREFIX/include/libpng16\""

./build-skia.sh