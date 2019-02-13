#!../../bin/windows-x64/ILM200-IOC-01

## You may have to change ILM200 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/ILM200-IOC-01.dbd"
ILM200_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocILM200-IOC-01/st-common.cmd
