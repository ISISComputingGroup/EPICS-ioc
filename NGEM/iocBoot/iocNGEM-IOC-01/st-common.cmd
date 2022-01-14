
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "20000000")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
asynSetMinTimerPeriod(0.001)

epicsEnvSet("NGEMCMD", "$(NGEM)/util/copycmd.bat")

## Device simulation mode IP configuration
drvAsynIPPortConfigure("NGEMIP","$(IPADDR=localhost:61000)")
asynOctetSetOutputEos("NGEMIP",0,"\n")
## we do not set an input EOS, we look to match ngem> in the driver
nGEMConfigure("NGEM","NGEMIP")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(NGEM)/db/nGEM.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=NGEM")
dbLoadRecords("$(NGEM)/db/nGEM_settings.db","P=$(MYPVPREFIX),Q=$(IOCNAME):SET:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=NGEM")
dbLoadRecords("$(NGEM)/db/nGEM_stats.db","P=$(MYPVPREFIX),Q=$(IOCNAME):STAT:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=NGEM")

# Load asyn record
dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(MYPVPREFIX),R=$(IOCNAME):ASYN,PORT=NGEMIP,ADDR=0,OMAX=256,IMAX=256")

##  TYPE=Float32,FTVL=FLOAT,DATATYPE=8 for 32 bit float
##  TYPE=Float64,FTVL=DOUBLE,DATATYPE=9 for 64 bit float

NDTransformConfigure("RawImage1", 3, 0, "NGEM", 0, 0)
NDROIConfigure("ROI1", 3, 0, "RawImage1", 0, 0)
NDStatsConfigure("Stats1", 3, 0, "ROI1", 0, 0)
NDTimeSeriesConfigure("Stats1_TS", 100, 0, "ROI1", 0, 22, 0, 0, 0, 0)
NDStdArraysConfigure("Image1", 3, 0, "ROI1", 0, 0)
NDPvaConfigure("PVA1", 3, 0, "ROI1", 0, "$(MYPVPREFIX)$(IOCNAME):AD:pva1:pvaData", 0)
KafkaPluginConfigure("KFK", 3, 1, "RawImage1", 0, -1, "livedata.isis.cclrc.ac.uk:9092", "$(INSTRUMENT=TEST)_areaDetector")

dbLoadRecords("$(NGEM)/db/nGEMAD.template","P=$(MYPVPREFIX),R=$(IOCNAME):AD:,PORT=NGEM,ADDR=0,TIMEOUT=1,DATATYPE=9")
dbLoadRecords("NDTransform.template", "P=$(MYPVPREFIX),R=$(IOCNAME):AD:rawimage1:,PORT=RawImage1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=NGEM,NDARRAY_ADDR=0,DATATYPE=9,ENABLED=1")
dbLoadRecords("NDROI.template", "P=$(MYPVPREFIX),R=$(IOCNAME):AD:roi1:,PORT=ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=RawImage1,NDARRAY_ADDR=0,DATATYPE=9,ENABLED=1")
dbLoadRecords("NDStats.template", "P=$(MYPVPREFIX),R=$(IOCNAME):AD:stats1:,PORT=Stats1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=ROI1,NDARRAY_ADDR=0,DATATYPE=9,ENABLED=1,NCHANS=1,XSIZE=1,YSIZE=1,HIST_SIZE=1")
dbLoadRecords("NDStdArrays.template", "P=$(MYPVPREFIX),R=$(IOCNAME):AD:image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=ROI1,NDARRAY_ADDR=0,DATATYPE=9,ENABLED=1,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=50000")
dbLoadRecords("NDPva.template", "P=$(MYPVPREFIX),R=$(IOCNAME):AD:pva1:,PORT=PVA1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=ROI1,NDARRAY_ADDR=0,DATATYPE=9,ENABLED=1")
dbLoadRecords("$(ADPLUGINKAFKA)/db/ADPluginKafka.template", "P=$(MYPVPREFIX),R=$(IOCNAME):AD:KFK:,PORT=KFK,ADDR=0,TIMEOUT=1,NDARRAY_PORT=RawImage1,ENABLED=1")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
