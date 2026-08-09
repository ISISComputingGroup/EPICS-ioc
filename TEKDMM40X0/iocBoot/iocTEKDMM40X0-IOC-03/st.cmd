#!../../bin/windows-x64-debug/TEKDMM40X0-IOC-03

## You may have to change TEKDMM40X0-IOC-03 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths



cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/TEKDMM40X0-IOC-03.dbd"
TEKDMM40X0_IOC_03_registerRecordDeviceDriver pdbbase

< ${TOP}/iocBoot/iocTEKDMM40X0-IOC-03/st-common.cmd


