#!../../bin/windows-x64/LKSH218-IOC-01

## You may have to change Lakeshore_218-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "TTY" "$(PORT)"                                   

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/LKSH218-IOC-01.dbd"
LKSH218_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocLKSH218-IOC-01

< st-common.cmd
