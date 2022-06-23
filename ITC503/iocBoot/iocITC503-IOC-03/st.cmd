#!../../bin/windows-x64/ITC503-IOC-03

## You may have to change ITC503-IOC-03 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/ITC503-IOC-03.dbd"
ITC503_IOC_03_registerRecordDeviceDriver pdbbase

## calling common command file in ioc 01 boot dir
< $(TOP)/iocboot/iocITC503-IOC-01/st-common.cmd
