#!../../bin/windows-x64/ENVMON-IOC-01

## You may have to change ENVMON to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/ENVMON-IOC-01.dbd"
ENVMON_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocENVMON-IOC-01/st-common.cmd
