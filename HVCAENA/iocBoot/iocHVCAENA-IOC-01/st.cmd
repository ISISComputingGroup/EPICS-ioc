#!../../bin/windows-x64-debug/HVCAENA-IOC-01

## You may have to change HVCAENA-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/HVCAENA-IOC-01.dbd"
HVCAENA_IOC_01_registerRecordDeviceDriver pdbbase

< iocBoot/iocHVCAENA-IOC-01/st-common.cmd
