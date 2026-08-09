#!../../bin/windows-x64/ENVMON-IOC-02

## You may have to change ENVMON to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/ENVMON-IOC-02.dbd"
ENVMON_IOC_02_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocENVMON-IOC-01/st-common.cmd
