epicsEnvSet "STREAM_PROTOCOL_PATH" "$(ITC503)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
epicsEnvSet "DEVICE" "L0"
epicsEnvSet "NAME" "HE3POT_HIGHT"
epicsEnvSet "PORT" "$(HE3POT_HIGHT_PORT=NO_PORT_MACRO)"
epicsEnvSet "BAUD" "$(HE3POT_HIGHT_BAUD=9600)"
epicsEnvSet "BITS" "$(HE3POT_HIGHT_BITS=8)"
epicsEnvSet "PARITY" "$(HE3POT_HIGHT_PARITY=none)"
epicsEnvSet "STOP" "$(HE3POT_HIGHT_STOP=2)"
epicsEnvSet "EMULATOR_PORT" "$(HE3POT_HIGHT_EMULATOR_PORT=)"
epicsEnvSet "READASCII_NAME" "HE3POT_HIGHT_READASCII"
< ${TOP}/iocBoot/iocHLX503-IOC-01/st-itc.cmd

epicsEnvSet "DEVICE" "L1"
epicsEnvSet "NAME" "HE3POT_LOWT"
epicsEnvSet "PORT" "$(HE3POT_LOWT_PORT=NO_PORT_MACRO)"
epicsEnvSet "BAUD" "$(HE3POT_LOWT_BAUD=9600)"
epicsEnvSet "BITS" "$(HE3POT_LOWT_BITS=8)"
epicsEnvSet "PARITY" "$(HE3POT_LOWT_PARITY=none)"
epicsEnvSet "STOP" "$(HE3POT_LOWT_STOP=2)"
epicsEnvSet "EMULATOR_PORT" "$(HE3POT_LOWT_EMULATOR_PORT=)"
epicsEnvSet "READASCII_NAME" "HE3POT_LOWT_READASCII"
< ${TOP}/iocBoot/iocHLX503-IOC-01/st-itc.cmd

epicsEnvSet "DEVICE" "L2"
epicsEnvSet "NAME" "1KPOT"
epicsEnvSet "PORT" "$(1KPOT_PORT=NO_PORT_MACRO)"
epicsEnvSet "BAUD" "$(1KPOT_BAUD=9600)"
epicsEnvSet "BITS" "$(1KPOT_BITS=8)"
epicsEnvSet "PARITY" "$(1KPOT_PARITY=none)"
epicsEnvSet "STOP" "$(1KPOT_STOP=2)"
epicsEnvSet "EMULATOR_PORT" "$(1KPOT_EMULATOR_PORT=)"
epicsEnvSet "READASCII_NAME" "1KPOT_READASCII"
< ${TOP}/iocBoot/iocHLX503-IOC-01/st-itc.cmd

epicsEnvSet "DEVICE" "L3"
epicsEnvSet "NAME" "SORB"
epicsEnvSet "PORT" "$(SORB_PORT=NO_PORT_MACRO)"
epicsEnvSet "BAUD" "$(SORB_BAUD=9600)"
epicsEnvSet "BITS" "$(SORB_BITS=8)"
epicsEnvSet "PARITY" "$(SORB_PARITY=none)"
epicsEnvSet "STOP" "$(SORB_HIGHT_STOP=2)"
epicsEnvSet "EMULATOR_PORT" "$(SORB_EMULATOR_PORT=)"
epicsEnvSet "READASCII_NAME" "SORB_READASCII"
< ${TOP}/iocBoot/iocHLX503-IOC-01/st-itc.cmd


dbLoadRecords("$(HLX503)/db/hlx503.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=ltu34219"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
