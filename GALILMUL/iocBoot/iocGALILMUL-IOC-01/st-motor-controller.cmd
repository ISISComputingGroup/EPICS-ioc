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
$(IFHASMTRCTRL$(CN)) stringiftest("HASMTRCTRL", "$(MTRCTRL=)", 0, 0)
$(IFHASMTRCTRL$(CN)) $(IFNOTHASMTRCTRL) errlogSev(2, "MTRCTRL has not been set")
