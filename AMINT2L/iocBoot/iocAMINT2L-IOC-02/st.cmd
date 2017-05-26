#!../../bin/windows-x64/AMINT2L-IOC-02

## You may have to change AMINT2L to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/AMINT2L-IOC-02.dbd"
AMINT2L_IOC_02_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocAMINT2L-IOC-01/st-common.cmd
