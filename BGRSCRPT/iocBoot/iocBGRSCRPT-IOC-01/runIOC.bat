@echo off
setlocal
set MYDIRBLOCK=%~dp0
call C:\Instrument\Apps\EPICS\config_env_base.bat

%HIDEWINDOW% h

set EPICS_CAS_INTF_ADDR_LIST=127.0.0.1
set EPICS_CAS_BEACON_ADDR_LIST=127.255.255.255

set PYTHONUNBUFFERED=TRUE

%PYTHON3W% %ICPINSTSCRIPTROOT%/background_script.py
