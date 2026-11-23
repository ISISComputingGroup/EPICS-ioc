@echo off
setlocal
set "MYIOCNAME=LSICORR_02"

set "IOC=iocLSICORR-IOC-02"
set "TOP=../.."

call %~dp0..\iocLSICORR-IOC-01\runIOC.bat
