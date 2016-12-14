#!../../bin/linux-x86_64/nanodac

## You may have to change nanodac to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/nanodac.dbd"
NANODAC_registerRecordDeviceDriver pdbbase

####################################################
# TCP to Eurotherm

epicsEnvSet("IP_ADDR","127.0.0.0:9999")

####################################################

####################################################################
# Set up modbus TCP support for Eurotherm

epicsEnvSet("NI","1")

< $(NANODAC)/st.cmd.main

< $(NANODAC)/st.cmd.loop1

< $(NANODAC)/st.cmd.loop2

< $(NANODAC)/st.cmd.user

< $(NANODAC)/st.cmd.alarm

####################################################################

## Load record instances
dbLoadRecords "db/nanodac.db"

cd ${TOP}/iocBoot/${IOC}
iocInit

