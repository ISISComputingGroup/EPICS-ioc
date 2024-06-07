

## create STRING_PORT (Required for String and Enum template)
$(IFNOTRECSIM) drvAsynIPPortConfigure("$(STRING_PORT)", "$(IPADDR):64008 TCP")
$(IFNOTRECSIM) asynOctetConnect("STRINGINIT","$(STRING_PORT)")
$(IFNOTRECSIM) asynOctetWrite("STRINGINIT" "*IDN? ")
$(IFRECSIM) drvAsynSerialPortConfigure("$(STRING_PORT)", "$(PORT=NUL)", 0, 1, 0, 0)
## create NUM_PORT (Requred for binary, enum and double template)
$(IFNOTRECSIM) drvAsynIPPortConfigure("$(NUM_PORT)", "$(IPADDR):64009 TCP")
$(IFNOTRECSIM) asynOctetConnect("NUMINIT","$(NUM_PORT)")
$(IFNOTRECSIM) asynOctetWrite("NUMINIT" "*IDN? ")
$(IFRECSIM) drvAsynSerialPortConfigure("$(NUM_PORT)", "$(PORT=NUL)", 0, 1, 0, 0)
# Wait for labview to initalise
$(IFNOTRECSIM) epicsThreadSleep(5)
#$(IFNOTRECSIM) asynSetTraceIOMask("$(NUM_PORT)", -1, 0x4)
#$(IFNOTRECSIM) asynSetTraceMask("$(NUM_PORT)", -1, 0x9)
## Load our record instances
dbLoadRecords("$(TOP)/db/lvremote_dds_tensile_stress_rig.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),IFNOTRECSIM=$(IFNOTRECSIM),DISABLE=$(DISABLE=0),STRING_PORT=$(STRING_PORT), NUM_PORT=$(NUM_PORT)")

