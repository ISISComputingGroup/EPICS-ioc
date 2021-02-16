#!../../bin/windows-x64/HLX503-IOC-01

## You may have to change HLX503 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/HLX503-IOC-01.dbd"
HLX503_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocHLX503-IOC-01/st-common.cmd
