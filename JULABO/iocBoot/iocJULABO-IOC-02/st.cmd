#!../../bin/windows-x64-debug/JULABO-IOC-02

## You may have to change JULABO-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

## Set the specific db file to use here because the command set can vary across models
epicsEnvSet "DB_FILE" "db/FP50_MH.db"

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/JULABO-IOC-02.dbd"
JULABO_IOC_02_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/iocJULABO-IOC-01

< st-common.cmd
