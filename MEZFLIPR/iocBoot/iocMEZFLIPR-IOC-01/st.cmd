#!../../bin/windows-x64/MEZFLIPR-IOC-01

## You may have to change MEZFLIPR to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/MEZFLIPR-IOC-01.dbd"
MEZFLIPR_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocMEZFLIPR-IOC-01/st-common.cmd
