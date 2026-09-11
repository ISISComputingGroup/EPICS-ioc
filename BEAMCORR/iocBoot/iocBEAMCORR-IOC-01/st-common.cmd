##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## No need to load a device, this only talks to other iocs


## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
stringiftest("IN:HIFI", "$(MYPVPREFIX)" 5 "IN:HIFI")
stringiftest("", "$(MYPVPREFIX)" 5 "IN:HIFI")
$(IFIN:HIFI) epicsEnvSet "NUM_STEER" "4"
$(IFNOTIN:HIFI) epicsEnvSet "NUM_STEER" "2"
## Un-comment for super MUSR
# epicsEnvSet "NUM_STEER" "6"

dbLoadRecords("${TOP}/db/beamcorr.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), NUM_STEER=$(NUM_STEER), HIFI_PV_MAIN=$(HIFI_PV_MAIN=),HIFI_PV_TRANS=$(HIFI_PV_TRANS=),EMU_PV_MAIN=$(EMU_PV_MAIN=),EMU_PV_TRANS=$(EMU_PV_TRANS=),MUSR_PV_MAIN=$(MUSR_PV_MAIN=),MUSR_PV_TRANS=$(MUSR_PV_TRANS=),IFRECSIM=$(IFRECSIM=), IFNOTRECSIM=$(IFNOTRECSIM=)")
dbLoadRecordsLoop("${TOP}/db/coefficients.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),STEER_MAG=\$(I)", "I", "1", "$(NUM_STEER)")
dbLoadRecords("${TOP}/db/steering.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), STEER_MAG=1, STEER_PV=$(STEER_1_PV=) IFRECSIM=$(IFRECSIM=), IFNOTRECSIM=$(IFNOTRECSIM=)")
dbLoadRecords("${TOP}/db/steering.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), STEER_MAG=2, STEER_PV=$(STEER_2_PV=) IFRECSIM=$(IFRECSIM=), IFNOTRECSIM=$(IFNOTRECSIM=)")

stringiftest("2_STEER", "$(NUM_STEER)" 5 "2")
$(IFNOT2_STEER)dbLoadRecords("${TOP}/db/steering.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), STEER_MAG=3, STEER_PV=$(STEER_3_PV=) IFRECSIM=$(IFRECSIM=), IFNOTRECSIM=$(IFNOTRECSIM=)")
$(IFNOT2_STEER)dbLoadRecords("${TOP}/db/steering.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), STEER_MAG=4, STEER_PV=$(STEER_4_PV=) IFRECSIM=$(IFRECSIM=), IFNOTRECSIM=$(IFNOTRECSIM=)")

stringiftest("6_STEER", "$(NUM_STEER)" 5 "6")
$(IF6_STEER)dbLoadRecords("${TOP}/db/steering.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), STEER_MAG=5, STEER_PV=$(STEER_5_PV=) IFRECSIM=$(IFRECSIM=), IFNOTRECSIM=$(IFNOTRECSIM=)")
$(IF6_STEER)dbLoadRecords("${TOP}/db/steering.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), STEER_MAG=6, STEER_PV=$(STEER_6_PV=) IFRECSIM=$(IFRECSIM=), IFNOTRECSIM=$(IFNOTRECSIM=)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit


##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
