#!../../bin/windows-x64/PIMOT-IOC-01

## You may have to change PIMOT to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/PIMOT-IOC-01.dbd"
KEPCO_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocPIMOT-IOC-01

< st-common.cmd
