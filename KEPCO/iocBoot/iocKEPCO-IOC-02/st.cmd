#!../../bin/windows-x64/KEPCO-IOC-02

## You may have to change kepco to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/KEPCO-IOC-02.dbd"
KEPCO_IOC_02_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocKEPCO-IOC-01

< st-common.cmd

