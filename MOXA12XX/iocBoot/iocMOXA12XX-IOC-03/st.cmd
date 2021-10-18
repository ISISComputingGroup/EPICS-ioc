#!../../bin/windows-x64/MOXA12XX-IOC-03

## You may have to change MOXA12XX-IOC-03 to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/MOXA12XX-IOC-03.dbd"
MOXA12XX_IOC_03_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC common boot file
< ${TOP}/iocBoot/iocMOXA12XX-IOC-01/st-common.cmd
