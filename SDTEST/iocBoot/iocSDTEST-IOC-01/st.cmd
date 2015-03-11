#!../../bin/win32-x86/SDTEST-IOC-01

## You may have to change SDTEST-IOC-01 to something else
## everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase("../../dbd/SDTEST-IOC-01.dbd",0,0)
SDTEST_IOC_01_registerRecordDeviceDriver(pdbbase) 

< $(IOCSTARTUP)/init.cmd

## set path to stream driver protocol file referenced in db files
epicsEnvSet ("STREAM_PROTOCOL_PATH", "$(TOP)/data")

drvAsynIPPortConfigure ("SD1", "130.246.51.169:23")

#drvAsynSerialPortConfigure ("SD1", "COM1")
#asynSetOption ("SD1", 0, "baud", "9600")
#asynSetOption ("SD1", 0, "baud", "115200")
#asynSetOption ("SD1", 0, "bits", "8")
#asynSetOption ("SD1", 0, "parity", "none")
#asynSetOption ("SD1", 0, "stop", "1")
#asynSetOption ("SD1", 0, "clocal", "Y")
#asynSetOption ("SD1", 0, "crtscts", "N")
#asynOctetSetOutputEos("SD1",0,"\r\n")
#asynOctetSetInputEos("SD1",0,"\r\n")

## Load record instances
dbLoadRecords("../../db/SDTEST-IOC-01.db","P=$(MYPVPREFIX),PORT=SD1")

iocInit()
