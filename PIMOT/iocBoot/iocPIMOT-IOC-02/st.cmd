#!../../bin/windows-x64/PIMOT-IOC-02

## You may have to change PIMOT to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/PIMOT-IOC-02.dbd"
KEPCO_IOC_02_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocPIMOT-IOC-01

< st-common.cmd
