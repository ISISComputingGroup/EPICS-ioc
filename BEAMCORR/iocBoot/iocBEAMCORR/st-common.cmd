epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## No need to load a device, this only talks to other iocs


## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("${TOP}/db/beamcorr.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("${TOP}/db/coefficients.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),STEER_1_HIFI_PV=$(STEER_1_HIFI_PV),HIFI_PV_MAIN=$(HIFI_PV_MAIN),HIFI_PV_TRANS=$(HIFI_PV_TRANS),STEER_2_HIFI_PV=$(STEER_2_HIFI_PV),STEER_3_HIFI_PV=$(STEER_3_HIFI_PV),EMU_PV_MAIN=$(EMU_PV_MAIN),EMU_PV_TRANS=$(EMU_PV_TRANS),STEER_4_HIFI_PV=$(STEER_4_HIFI_PV),MUSR_PV_MAIN=$(MUSR_PV_MAIN),MUSR_PV_TRANS=$(MUSR_PV_TRANS),STEER_1_EMU_PV=$(STEER_1_EMU_PV),STEER_2_EMU_PV=$(STEER_2_EMU_PV),STEER_1_MUSR_PV=$(STEER_1_MUSR_PV),STEER_2_MUSR_PV=$(STEER_2_MUSR_PV)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit


##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
