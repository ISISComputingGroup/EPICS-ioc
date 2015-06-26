#!../../bin/windows-x64/GALIL-IOC-07

## You may have to change GALIL-IOC-07 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/GALIL-IOC-07.dbd"
GALIL_IOC_07_registerRecordDeviceDriver pdbbase

cd "${TOP}/iocBoot/iocGALIL-IOC-01"

< st-common.cmd
