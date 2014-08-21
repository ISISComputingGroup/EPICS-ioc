#!../../bin/windows-x64/GALIL-IOC-02

## You may have to change GALIL-IOC-02 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/GALIL-IOC-02.dbd"
GALIL_IOC_02_registerRecordDeviceDriver pdbbase

cd "${TOP}/iocBoot/iocGALIL-IOC-01"

< st-common.cmd
