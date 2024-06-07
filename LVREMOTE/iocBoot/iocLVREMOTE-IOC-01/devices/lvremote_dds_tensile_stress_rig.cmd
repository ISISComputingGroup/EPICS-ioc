

## create STRING_PORT (Required for String and Enum template)
drvAsynIPPortConfigure("$(STRING_PORT)", "$(IPADDR):64008 TCP")
asynOctetConnect("STRINGINIT","$(STRING_PORT)")
asynOctetWrite("STRINGINIT" "*IDN? ")

## create NUM_PORT (Requred for binary, enum and double template)
drvAsynIPPortConfigure("$(NUM_PORT)", "$(IPADDR):64009 TCP")
asynOctetConnect("NUMINIT","$(NUM_PORT)")
asynOctetWrite("NUMINIT" "*IDN? ")
# Wait for labview to initalise
epicsThreadSleep(5)
asynSetTraceIOMask("$(NUM_PORT)", -1, 0x2)
asynSetTraceMask("$(NUM_PORT)", -1, 0x9)
## Load our record instances
dbLoadRecords("$(TOP)/db/lvremote_dds_tensile_stress_rig.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),STRING_PORT=$(STRING_PORT), NUM_PORT=$(NUM_PORT)")
