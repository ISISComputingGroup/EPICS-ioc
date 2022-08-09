@echo off
setlocal
set MYDIRBLOCK=%~dp0
call C:\Instrument\Apps\EPICS\config_env_base.bat
call dllPath.bat
%HIDEWINDOW% h

set EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
set EPICS_CAS_BEACON_ADDR_LIST=127.255.255.255

set PYTHONUNBUFFERED=TRUE

set "GETMACRO=C:\Instrument\Apps\EPICS\support\icpconfig\master\bin\%EPICS_HOST_ARCH%\icpconfigGetMacro.exe"
set "MYIOCNAME=BGRSCRPT_01"

echo PRE %MACRO%

echo Defining macro
REM need this funny syntax to be able to set eol correctly - see google
for /f usebackq^ tokens^=*^ delims^=^ eol^= %%a in ( `%GETMACRO% "SCRIPT_PATH" %MYIOCNAME%`  ) do ( set "MACRO=%%a" )

if "%MACRO%"=="" (
    echo Setting default path
    set "MACRO=%ICPINSTSCRIPTROOT%/background_script.py"
)

echo Macro is %MACRO%

%PYTHON3W% %MACRO%
