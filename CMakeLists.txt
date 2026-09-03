cmake_minimum_required(VERSION 3.15)
project(qskia CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

option(SKIA_DEPS_STATIC "Skia dependencies have been statically linked" OFF)

if(CMAKE_SYSTEM_NAME STREQUAL Linux)
    set(A l)
elseif(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    set(A m)
elseif(CMAKE_SYSTEM_NAME STREQUAL Windows)
    set(A w)
else()
    message(FATAL_ERROR "Unsupported OS")
endif()

if(APPLE)
    if(CMAKE_OSX_ARCHITECTURES MATCHES "arm64")
        set(A "${A}a64")
    elseif(CMAKE_OSX_ARCHITECTURES MATCHES "x86_64")
        set(A "${A}i64")
    else()
        message(FATAL_ERROR "Unsupported macOS architecture")
    endif()
else()
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
        set(A "${A}i64")
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64")
        set(A "${A}a64")
    else()
        message(FATAL_ERROR "Unsupported processor architecture")
    endif()
endif()

message(STATUS "A: ${A}")

message(STATUS "Generator : ${CMAKE_GENERATOR}")
message(STATUS "Build Tool : ${CMAKE_BUILD_TOOL}")

set(MY_LIBRARY_NAME "skia.${A}")

file(GLOB SRC_FILES src/*.cpp)
set_source_files_properties(${SRC_FILES} PROPERTIES LANGUAGE CXX)

add_library(${MY_LIBRARY_NAME} MODULE ${SRC_FILES})
set_target_properties(${MY_LIBRARY_NAME} PROPERTIES PREFIX "")

target_compile_definitions(${MY_LIBRARY_NAME} PRIVATE KXVER=3)

if(MSVC)
    target_compile_options(${MY_LIBRARY_NAME} PRIVATE /W4 /wd4244 /wd4996 /wd4067 /wd4267 /wd4458 /wd4100)
else()
    target_compile_options(${MY_LIBRARY_NAME} PRIVATE -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable)
endif()

set(SKIA_DIR ${PROJECT_SOURCE_DIR}/deps/skia)
set(SKIA_INC ${SKIA_DIR}/include)
target_include_directories(${MY_LIBRARY_NAME} PRIVATE ${SKIA_DIR} ${SKIA_INC}/core ${SKIA_INC}/encode ${SKIA_INC}/effects ${SKIA_INC}/ports)
target_link_directories(${MY_LIBRARY_NAME} PRIVATE ${PROJECT_SOURCE_DIR} ${SKIA_DIR}/out/Static)
if(WIN32)
    set(SKIA_LIBRARY skia.lib)
else()
    set(SKIA_LIBRARY libskia.a)
endif()
target_link_libraries(${MY_LIBRARY_NAME} PRIVATE ${SKIA_LIBRARY})

if(APPLE)
    target_link_options(${MY_LIBRARY_NAME} PRIVATE -undefined dynamic_lookup -Qunused-arguments)
    target_link_libraries(${MY_LIBRARY_NAME} PRIVATE "-framework CoreFoundation" "-framework CoreText")
endif()

if(NOT SKIA_DEPS_STATIC)
    find_package(Freetype REQUIRED)
    target_link_libraries(${MY_LIBRARY_NAME} PRIVATE Freetype::Freetype)

    if(WIN32)
        find_package(PNG REQUIRED)
        target_link_libraries(${MY_LIBRARY_NAME} PRIVATE PNG::PNG)
    endif()
endif()

if(WIN32)
    target_link_libraries(${MY_LIBRARY_NAME} PRIVATE q.lib)
endif()

if(DEFINED ENV{PREFIX})
    set(MOD_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/lib/q/mod/kx)
    set(FONTS_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/fonts)
else()
    set(MOD_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/kx)
    set(FONTS_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/kx/fonts)
endif()

install(TARGETS ${MY_LIBRARY_NAME} DESTINATION ${MOD_INSTALL_DIR})

install(DIRECTORY fonts/ivyfonts DESTINATION ${FONTS_INSTALL_DIR} PATTERN "*/LICENSE_OFL.txt" EXCLUDE)

if(NOT DEFINED ENV{PREFIX})
    install(DIRECTORY licenses DESTINATION ${CMAKE_INSTALL_PREFIX}/kx)
endif()
