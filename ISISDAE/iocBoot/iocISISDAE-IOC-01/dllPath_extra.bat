@ECHO OFF

REM on build servers or developer computers we may not have NI VISA installed
for %%i in ( visa64.dll ) do SET "MYVISAPATH=%%~dp$PATH:i"
if "%MYVISAPATH%" == "" (
    SET "PATH=%PATH%;%EPICS_KIT_ROOT%\ICP_Binaries\isisdae\visa"
)

REM add path to debug libraries in case needed for running debug build
REM we usually install vs2015 redistributable for release builds
for %%i in ( vcruntime140d.dll ) do SET "MYDBGCRTPATH=%%~dp$PATH:i"
if "%MYDBGCRTPATH%" == "" (
    SET "PATH=%PATH%;%EPICS_KIT_ROOT%\ICP_Binaries\isisdae\x64\crt\debug"
)
set MYVISAPATH=
set MYDBGCRTPATH=
