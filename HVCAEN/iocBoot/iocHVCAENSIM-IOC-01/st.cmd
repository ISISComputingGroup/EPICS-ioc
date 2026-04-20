#!../../bin/windows-x64-debug/HVCAEN-IOC-01

## You may have to change HVCAEN-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/HVCAENSIM-IOC-01.dbd"
HVCAENSIM_IOC_01_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< ${TOP}/iocBoot/iocHVCAEN-IOC-01/st-common.cmd
