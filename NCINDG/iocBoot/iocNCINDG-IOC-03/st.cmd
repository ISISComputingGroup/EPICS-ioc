#!../../bin/windows-x64/NCINDG-IOC-02

## You may have to change NCINDG-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/NCINDG-IOC-03.dbd"
NCINDG_IOC_03_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocNCINDG-IOC-01/st-common.cmd
