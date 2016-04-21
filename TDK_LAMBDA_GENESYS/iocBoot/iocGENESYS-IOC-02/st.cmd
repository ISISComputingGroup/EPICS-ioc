#!../../bin/windows-x64/GENESYS-IOC-02

## You may have to change GENESYS-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

## Register all support components
dbLoadDatabase ("$(TOP)/dbd/GENESYS-IOC-02.dbd",0,0)
GENESYS_IOC_02_registerRecordDeviceDriver pdbbase

cd ../iocGENESYS-IOC-01

< st-common.cmd
