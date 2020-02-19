#!../../bin/windows-x64/y

## You may have to change y to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "${TOP}/dbd/TWINCAT-IOC-01.dbd"
TWINCAT_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocTWINCAT-IOC-01/st-common.cmd
