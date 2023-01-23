#!../../bin/windows-x64/KHLY2000-IOC-02

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/KHLY2000-IOC-02.dbd"
KHLY2000_IOC_02_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocKHLY2000-IOC-01/st-common.cmd
