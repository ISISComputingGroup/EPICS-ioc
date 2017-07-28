#!../../bin/windows-x64/LAKESHORE460-IOC-01

## You may have to change LAKESHORE460 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/LAKESHORE460-IOC-01.dbd"
AMINT2L_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocLAKESHORE460-IOC-01/st-common.cmd
