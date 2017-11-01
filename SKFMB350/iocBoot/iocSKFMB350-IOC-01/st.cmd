#!../../bin/windows-x64/SKFMB350-IOC-01

## You may have to change XXXX to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/SKFMB350-IOC-01.dbd"
SKFMB350_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocSKFMB350-IOC-01/st-common.cmd
