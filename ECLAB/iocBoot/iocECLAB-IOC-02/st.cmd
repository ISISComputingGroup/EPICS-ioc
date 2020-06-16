#!../../bin/windows-x64-debug/ECLAB-IOC-02

## You may have to change ECLAB-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/ECLAB-IOC-02.dbd"
ECLAB_IOC_02_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/ioc_01_APP_NAME_/st-common.cmd
