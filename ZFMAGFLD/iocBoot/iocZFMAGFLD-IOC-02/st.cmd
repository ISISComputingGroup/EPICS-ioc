#!../../bin/windows-x64/ZFMAGFLD-IOC-02

## You may have to change ZFMAGFLD-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/ZFMAGFLD-IOC-02.dbd"
ZFMAGFLD_IOC_02_registerRecordDeviceDriver pdbbase

< ${TOP}/iocBoot/iocZFMAGFLD-IOC-01/st-common.cmd

