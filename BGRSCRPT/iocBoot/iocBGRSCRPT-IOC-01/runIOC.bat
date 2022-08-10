@echo off
setlocal
set MYDIRBLOCK=%~dp0
call %~dp0..\..\..\..\..\config_env_base.bat
call dllPath.bat
%HIDEWINDOW% h

set EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
set EPICS_CAS_BEACON_ADDR_LIST=127.255.255.255

set PYTHONUNBUFFERED=TRUE

set "GETMACRO=%EPICS_KIT_ROOT%\support\icpconfig\master\bin\%EPICS_HOST_ARCH%\icpconfigGetMacro.exe"
set "MYIOCNAME=BGRSCRPT_01"

REM for loop is used to capture the output
for /f %%a in ( '%GETMACRO% "SCRIPT_PATH" %MYIOCNAME%'  ) do ( set "SCRIPT_PATH_MACRO=%%a" )

if "%SCRIPT_PATH_MACRO%"=="" (
    set "SCRIPT_PATH_MACRO=%ICPINSTSCRIPTROOT%/background_script.py"
)

%PYTHON3W% %SCRIPT_PATH_MACRO%
