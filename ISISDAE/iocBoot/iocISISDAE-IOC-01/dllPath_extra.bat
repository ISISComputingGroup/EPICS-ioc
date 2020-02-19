@ECHO OFF
REM on build servers or developer computers we may not have NI VISA installed
for %%i in ( visa64.dll ) do SET "MYVISAPATH=%%~dp$PATH:i"
if "%MYVISAPATH%" == "" (
    SET "PATH=%PATH%;%EPICS_KITS_ROOT%\ICP_Binaries\isisdae\visa"
)
set MYVISAPATH=
