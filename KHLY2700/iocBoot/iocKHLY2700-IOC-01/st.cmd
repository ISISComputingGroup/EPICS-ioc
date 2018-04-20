#!../../bin/windows-x64/KHLY2700-IOC-01

## You may have to change LKSH460 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/KHLY2700-IOC-01.dbd"
KHLY2700_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocKHLY2700-IOC-01/st-common.cmd
