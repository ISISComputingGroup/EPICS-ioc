#!../../bin/windows-x64/NEOCERA-IOC-02

## You may have to change NEOCERA-IOC-02 to something else
## everywhere it appears in this file

< envPaths

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

## Register all support components
dbLoadDatabase "${TOP}/dbd/NEOCERA-IOC-02.dbd"
NEOCERA_IOC_02_registerRecordDeviceDriver pdbbase

< ../iocNeocera-IOC-01/st-common.cmd
