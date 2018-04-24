#!../../bin/windows-x64/KHLY2700-IOC-02

## You may have to change KHLY2700-IOC-1 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/KHLY2700-IOC-02.dbd"
KHLY2700_IOC_02_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ../iocKHLY2700-IOC-01/st-common.cmd
