#!/bin/bash

CPP_FILE=hello.cpp

GCC_LIBS="-lboost_system -lpthread"
CLANG_LIBS=$GCC_LIBS

GCC_CXXFLAGS_DEBUG="$GCC_INCLUDE_PATHS -O0 -g -std=c++17 -Wall"
GCC_CXXFLAGS_RELEASE="$GCC_INCLUDE_PATHS -O2  -std=c++17 -Wall"
GCC_LINKFLAGS_DEBUG="$GCC_LIB_PATHS $GCC_LIBS"
GCC_LINKFLAGS_RELEASE="$GCC_LIB_PATHS $GCC_LIBS"

CLANG_CXXFLAGS_DEBUG=$GCC_CXXFLAGS_DEBUG
CLANG_CXXFLAGS_RELEASE=$GCC_CXXFLAGS_RELEASE
CLANG_LINKFLAGS_DEBUG=$GCC_LINKFLAGS_DEBUG
CLANG_LINKFLAGS_RELEASE=$GCC_LINKFLAGS_RELEASE


if [ -z "$CPP_TOOLCHAIN" ]; then
    echo CPP_TOOLCHAIN not set
    exit 1
fi
if [ -z "$BOOST_TOOLSET" ]; then
    echo BOOST_TOOLSET not set
    exit 1
fi
if [ -z "$DEBUG_RELEASE" ]; then
    echo DEBUG_RELEASE not set
    exit 1
fi
if [ -z "$ADDRESS_MODEL" ]; then
    echo ADDRESS_MODEL not set
    exit 1
fi
if [ -z "$BOOST_LIB_FOLDER" ]; then
    echo BOOST_LIB_FOLDER not set
    exit 1
fi

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p "${script_dir}/bin"
output_base_name="${script_dir}/bin/aa_${CPP_TOOLCHAIN}_${DEBUG_RELEASE}_${ADDRESS_MODEL}"
build_command=

gcc_cxx_flags=
gcc_link_flags=
clang_cxx_flags=
clang_link_flags=
if [ "$DEBUG_RELEASE" = "debug" ]; then
    gcc_cxx_flags=$GCC_CXXFLAGS_DEBUG
    gcc_link_flags=$GCC_LINKFLAGS_DEBUG
    clang_cxx_flags=$CLANG_CXXFLAGS_DEBUG
    clang_link_flags=$CLANG_LINKFLAGS_DEBUG
else
    gcc_cxx_flags=$GCC_CXXFLAGS_RELEASE
    gcc_link_flags=$GCC_LINKFLAGS_RELEASE
    clang_cxx_flags=$CLANG_CXXFLAGS_RELEASE
    clang_link_flags=$CLANG_LINKFLAGS_RELEASE
fi

if [ "$BOOST_TOOLSET" = "gcc" ]; then
    build_command="g++ -o ${output_base_name}\
        ${gcc_cxx_flags} ${script_dir}/${CPP_FILE} ${gcc_link_flags}"
fi

if [ "$BOOST_TOOLSET" = "clang" ]; then
    build_command="clang++ -o ${output_base_name}\
        ${clang_cxx_flags} ${script_dir}/${CPP_FILE} ${clang_link_flags}"
fi

if [ -z "$build_command" ]; then
    exit 1
fi

echo $build_command
$build_command
