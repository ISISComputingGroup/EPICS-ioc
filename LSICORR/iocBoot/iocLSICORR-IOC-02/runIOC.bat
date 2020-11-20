@echo off
setlocal
set MYDIRBLOCK=%~dp0
call C:\Instrument\Apps\EPICS\config_env_base.bat
call dllPath.bat
%HIDEWINDOW% h

set EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
set EPICS_CAS_BEACON_ADDR_LIST=127.255.255.255

set PYTHONUNBUFFERED=TRUE

set "GETMACROS=C:\Instrument\Apps\EPICS\support\icpconfig\master\bin\%EPICS_HOST_ARCH%\icpconfigGetMacros.exe"
set "MYIOCNAME=LSICORR_02"

if "%MACROS%"=="" (
    REM need this funny syntax to be able to set eol correctly - see google
    for /f usebackq^ tokens^=*^ delims^=^ eol^= %%a in ( `%GETMACROS% %MYIOCNAME%`  ) do ( set "MACROS=%%a" )
    echo Defining macros
) else (
    echo Macros already defined
)

%PYTHON3W% %EPICS_KIT_ROOT%/support/lsicorr/master/correlator_pcaspy.py --pv_prefix %MYPVPREFIX% --ioc_name %MYIOCNAME%
