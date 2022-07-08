#!../../bin/windows-x64/EUROMOD

## You may have to change EUROMOD to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "${TOP}/dbd/EUROMOD-IOC-01.dbd"
EUROMOD_IOC_01_registerRecordDeviceDriver pdbbase

< st-common.cmd
