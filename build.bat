
@echo off

set CPP_FILE=hello.cpp

set MSVC_LIBS=libboost_system.lib
set GCC_LIBS=-lboost_system

set MSVC_CXXFLAGS_DEBUG=/DBOOST_ALL_NO_LIB /EHsc /Zi /Od /MDd
set MSVC_CXXFLAGS_RELEASE=/DBOOST_ALL_NO_LIB /EHsc /Zi /O2 /MD
set MSVC_LINKFLAGS_DEBUG=/link %MSVC_LIBS%
set MSVC_LINKFLAGS_RELEASE=/link %MSVC_LIBS%

set GCC_CXXFLAGS_DEBUG=%GCC_INCLUDE_PATHS% -O0 -g
set GCC_CXXFLAGS_RELEASE=%GCC_INCLUDE_PATHS% -O2
set GCC_LINKFLAGS_DEBUG=%GCC_LIB_PATHS% %GCC_LIBS%
set GCC_LINKFLAGS_RELEASE=%GCC_LIB_PATHS% %GCC_LIBS%


if "%CPP_TOOLCHAIN%"=="" (
    echo CPP_TOOLCHAIN not set
    exit /b 1
)
if "%BOOST_TOOLSET%"=="" (
    echo BOOST_TOOLSET not set
    exit /b 1
)
if "%DEBUG_RELEASE%"=="" (
    echo DEBUG_RELEASE not set
    exit /b 1
)
if "%ADDRESS_MODEL%"=="" (
    echo ADDRESS_MODEL not set
    exit /b 1
)
if "%BOOST_LIB_FOLDER%"==""  (
    echo BOOST_LIB_FOLDER not set
    exit /b 1
)

mkdir "%~dp0\bin"
set output_base_name=%~dp0\bin\aa_%CPP_TOOLCHAIN%_%DEBUG_RELEASE%_%ADDRESS_MODEL%
set build_command=

set msvc_cxx_flags=
set msvc_link_flags=
set gcc_cxx_flags=
set gcc_link_flags=
if "%DEBUG_RELEASE%"=="debug" (
    set msvc_cxx_flags=%MSVC_CXXFLAGS_DEBUG%
    set msvc_link_flags=%MSVC_LINKFLAGS_DEBUG%
    set gcc_cxx_flags=%GCC_CXXFLAGS_DEBUG%
    set gcc_link_flags=%GCC_LINKFLAGS_DEBUG%
) else (
    set msvc_cxx_flags=%MSVC_CXXFLAGS_RELEASE%
    set msvc_link_flags=%MSVC_LINKFLAGS_RELEASE%
    set gcc_cxx_flags=%GCC_CXXFLAGS_RELEASE%
    set gcc_link_flags=%GCC_LINKFLAGS_RELEASE%
)

if "%BOOST_TOOLSET%"=="msvc" (
    set build_command=cl /Fd"%output_base_name%.pdb" /Fo"%output_base_name%.obj" /Fe"%output_base_name%.exe"^
        /nologo^ %msvc_cxx_flags% "%~dp0%CPP_FILE%" %msvc_link_flags%
)

if "%BOOST_TOOLSET%"=="gcc" (
    set build_command=g++ -o "%output_base_name%.exe"^
        %gcc_cxx_flags% "%~dp0%CPP_FILE%" %gcc_link_flags%
)

if "%build_command%"=="" (
    exit /b 1
)

echo %build_command%
%build_command%

