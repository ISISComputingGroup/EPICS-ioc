#!../../bin/windows-x64/SMRTMON-IOC-01

## You may have to change SMRTMON-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/SMRTMON-IOC-01.dbd"
SMRTMON_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocSMRTMON-IOC-01/st-common.cmd
