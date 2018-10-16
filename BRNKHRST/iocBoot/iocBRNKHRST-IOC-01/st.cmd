#!../../bin/windows-x64/BRNKHRST-IOC-01

## You may have to change BRNKHRST-IOC-01 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("${TOP}/dbd/BRNKHRST-IOC-01.dbd",0,0)
BRNKHRST_IOC_01_registerRecordDeviceDriver(pdbbase) 

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocBRNKHRST-IOC-01/st-common.cmd
