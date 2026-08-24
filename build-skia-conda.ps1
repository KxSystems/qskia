# Run this script from a Conda environment which has the freetype package installed
$env:USE_SYS="true"
$env:EXTRA_CFLAGS="\`"-I$env:CONDA_PREFIX\Library\include\`",\`"-DSK_FREETYPE_MINIMUM_RUNTIME_VERSION=0\`",\`"/MD\`""
.\build-skia.bat