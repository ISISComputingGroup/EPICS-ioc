#!../../bin/windows-x64/GALILMUL-IOC-02

## You may have to change GALILMUL-IOC-02 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/GALILMUL-IOC-02.dbd"
GALILMUL_IOC_02_registerRecordDeviceDriver pdbbase

cd "${TOP}/iocBoot/iocGALILMUL-IOC-01"

< st-common.cmd
