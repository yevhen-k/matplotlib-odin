@echo off

REM --- Build script  ---

REM --- Configuration ---
SET PY_VER=313
set SOURCE="src/lib/matplotlib.c"
set OUTPUTDLL="matplotlib.dll"
set PY_INCLUDE="C:/Program Files/Python%PY_VER%/Include/"
set NUMPY_INCLUDE="venv%PY_VER%/lib/site-packages/numpy/_core/include/"
set PY_LIB="C:/Program Files/Python%PY_VER%/python%PY_VER%.dll"
set PY_LIBS="C:/Program Files/Python%PY_VER%/libs/"
SET LIB_OUT="build\lib"
SET BIN_OUT="build\bin"

echo %PY_INCLUDE%
echo %NUMPY_INCLUDE%

REM --- Command Line Arguments ---
IF /I "%~1" == "" GOTO :eof
IF /I "%~1" == "clear" GOTO :clear
IF /I "%~1" == "build_dirs" GOTO :build_dirs
IF /I "%~1" == "build" GOTO :build
IF /I "%~1" == "mpl" GOTO :mpl
IF /I "%~1" == "bar" GOTO :bar
REM Add other potential arguments if needed


REM --- Targets / Build Steps (implemented as labels) ---
:build_dirs
echo Creating build directories...
REM mkdir -p equivalent
mkdir "%LIB_OUT%"
IF %ERRORLEVEL% NEQ 0 (
    echo Error creating %LIB_OUT%
    GOTO :error
)
mkdir "%BIN_OUT%"
IF %ERRORLEVEL% NEQ 0 (
    echo Error creating %BIN_OUT%
    GOTO :error
)
echo Directories created.
GOTO :eof

:clear
echo Cleaning build outputs...
REM Remove files (>/dev/null 2>&1 equivalent)
del /q "%BIN_OUT%\*" >nul 2>nul
del /q "%LIB_OUT%\*" >nul 2>nul
REM Remove directories (rmdir /s /q equivalent)
rmdir /s /q "%BIN_OUT%" >nul 2>nul
rmdir /s /q "%LIB_OUT%" >nul 2>nul
echo Clean complete.
GOTO :eof


:build
REM Compiling .obj and .dll files
cl /DLL /LD /WX /MD ^
    /I%PY_INCLUDE% ^
    /I%NUMPY_INCLUDE% ^
    /Fobuild\\lib\\ ^
    %SOURCE% ^
    /link /LIBPATH:%PY_LIBS% python%PY_VER%.lib ^
    /out:%LIB_OUT%/%OUTPUTDLL%
REM Linking .obj file into .lib file
lib %LIB_OUT%\matplotlib.obj

if %ERRORLEVEL% EQU 0 (
    echo Build successful! Matplotlib created at %BIN_OUT%
    GOTO :eof
) else (
    echo Build failed with error code %ERRORLEVEL%
    GOTO :error
)


:mpl
odin build src/ -out=%BIN_OUT%/matplotlib.exe ^
	-extra-linker-flags="/NODEFAULTLIB:MSVCRT /NODEFAULTLIB:libcmt msvcrtd.lib /LIBPATH:C:/PROGRA~1/Python%PY_VER%/libs python%PY_VER%.lib"
if %ERRORLEVEL% EQU 0 (
    echo Build successful! EXE created at %BIN_OUT%
    GOTO :eof
) else (
    echo Build failed with error code %ERRORLEVEL%
    GOTO :error
)


REM --- EXAMPLES ---
:bar
odin build examples/bar.odin -file -define:PY_VER=%PY_VER% -out=build/bin/bar.exe ^
  -extra-linker-flags="/NODEFAULTLIB:MSVCRT /NODEFAULTLIB:libcmt msvcrtd.lib /LIBPATH:C:/PROGRA~1/Python%PY_VER%/libs python%PY_VER%.lib"
if %ERRORLEVEL% EQU 0 (
    echo Build successful! EXE created at %BIN_OUT%
    GOTO :eof
) else (
    echo Build failed with error code %ERRORLEVEL%
    GOTO :error
)


REM --- Error Handling ---
:error
echo --- BUILD FAILED ---
EXIT /b 1

REM --- End of Script ---
:eof
