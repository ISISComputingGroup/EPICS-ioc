@echo off
setlocal
if exist "%~dp0..\..\..\..\..\config_env_base.bat" (
    call %~dp0..\..\..\..\..\config_env_base.bat
) else (
    call C:\Instrument\Apps\EPICS\config_env_base.bat
)
call %~dp0dllPath.bat
%HIDEWINDOW% h

set EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
set EPICS_CAS_BEACON_ADDR_LIST=127.255.255.255

set PYTHONUNBUFFERED=TRUE

set "GETMACROS=%EPICS_KIT_ROOT%\support\icpconfig\master\bin\%EPICS_HOST_ARCH%\icpconfigGetMacros.exe"
if "%MYIOCNAME%" == "" set "MYIOCNAME=LSICORR_01"

if "%MACROS%"=="" (
    REM need this funny syntax to be able to set eol correctly - see google
    for /f usebackq^ tokens^=*^ delims^=^ eol^= %%a in ( `%GETMACROS% %MYIOCNAME%`  ) do ( set "MACROS=%%a" )
    echo Defining macros
) else (
    echo Macros already defined
)

echo Macros are %MACROS%

"%PYTHON3W%" -u "%EPICS_KIT_ROOT%\support\lsicorr\master\correlator_pcaspy.py" --pv_prefix %MYPVPREFIX% --ioc_name %MYIOCNAME%
