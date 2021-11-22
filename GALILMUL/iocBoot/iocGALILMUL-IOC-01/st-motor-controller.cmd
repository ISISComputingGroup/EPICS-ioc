stringiftest("HASMTRCTRL$(CN)", "$(MTRCTRL$(CN)=)", 0, 0)

$(IFHASMTRCTRL$(CN)) epicsEnvSet("CCP", "$(MTRCTRL$(CN))")
$(IFHASMTRCTRL$(CN)) epicsEnvSet("MTRCTRL", "$(MTRCTRL$(CN))")
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) ## uncomment to see every command sent to every galil, of define in st.cmd for just one galil
$(IFHASMTRCTRL$(CN)) #epicsEnvSet("GALIL_DEBUG_FILE", "galil_debug.txt")
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) ## GALIL_MTR_PORT is the asyn port used to load just the motor record, other records 
$(IFHASMTRCTRL$(CN)) ## are loaded with "Galil" as the asyn port
$(IFHASMTRCTRL$(CN)) $(IFDEVSIM) epicsEnvSet("GALIL_MTR_PORT", "GalilSim$(CN)")
$(IFHASMTRCTRL$(CN)) $(IFRECSIM) epicsEnvSet("GALIL_MTR_PORT", "GalilSim$(CN)")
$(IFHASMTRCTRL$(CN)) $(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet("GALIL_MTR_PORT", "Galil$(CN)")
$(IFHASMTRCTRL$(CN)) epicsEnvSet("GALIL_PORT", "Galil$(CN)")
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) ## create simulated motor if required (asyn port "$(GALIL_MTR_PORT)")
$(IFHASMTRCTRL$(CN)) $(IFSIM) < motorsim.cmd
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) ## configure the galil, if we are simulated this will not be used to drive the 
$(IFHASMTRCTRL$(CN)) ## actual device, but creating this asyn port at least allows record initialisation 
$(IFHASMTRCTRL$(CN)) ## to complete
$(IFHASMTRCTRL$(CN)) $(IFNOTDEVSIM) $(IFNOTRECSIM) < $(GALILCONFIG)/galilmul$(MTRCTRL$(CN)).cmd
$(IFHASMTRCTRL$(CN)) ## load the galil db files
$(IFHASMTRCTRL$(CN)) < galildb.cmd
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) ## load the generic ISIS axis db for each axis
$(IFHASMTRCTRL$(CN)) iocshCmdLoop("< st-axis.cmd", "MN=\$(I)", "I", 1, 8)
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) ## motor util package
$(IFHASMTRCTRL$(CN)) dbLoadRecords("$(MOTOR)/db/motorUtil.db","P=$(MYPVPREFIX)$(IOCNAME):,$(IFIOC)= ,PVPREFIX=$(MYPVPREFIX)")
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) stringiftest("MOTORCONFIG", "$(MOTORCONFIG=)", 0, 0)
$(IFHASMTRCTRL$(CN)) $(IFMOTORCONFIG) dbLoadRecords("$(AUTOSAVE)/asApp/Db/configMenu.db","P=$(MYPVPREFIX)$(IOCNAME):CONFIG:,CONFIG=$(MOTORCONFIG=)")
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) ##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
$(IFHASMTRCTRL$(CN)) < $(IOCSTARTUP)/preiocinit.cmd
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) ## trace mask: 0x1=trace_error,0x2=traceio_device,0x4=traceio_filter, 0x8=traceio_driver, 0x10=trace_flow, 0x20=trace_warning  
$(IFHASMTRCTRL$(CN)) #asynSetTraceMask("Galil",-1,0x39)
$(IFHASMTRCTRL$(CN)) #asynSetTraceFile("Galil",-1,"galil.trace")
$(IFHASMTRCTRL$(CN)) #asynSetTraceIOMask("Galil",-1,0x2)
$(IFHASMTRCTRL$(CN)) 
$(IFHASMTRCTRL$(CN)) stringiftest("HASMTRCTRL", "$(MTRCTRL=)", 0, 0)
$(IFHASMTRCTRL$(CN)) $(IFNOTHASMTRCTRL) errlogSev(2, "MTRCTRL has not been set")
