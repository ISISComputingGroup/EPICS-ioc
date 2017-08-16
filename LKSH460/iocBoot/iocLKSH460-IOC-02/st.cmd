#!../../bin/windows-x64/LKSH460-IOC-02

## You may have to change LKSH460 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/LKSH460-IOC-02.dbd"
LKSH460_IOC_02_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocLKSH460-IOC-01/st-common.cmd
