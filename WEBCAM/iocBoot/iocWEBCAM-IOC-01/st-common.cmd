##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# The search path for database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
epicsEnvSet("PREFIX", "$(MYPVPREFIX)$(IOCNAME):")
epicsEnvSet("PORT", "Cam1")

# Create a URL driver
# URLDriverConfig(const char *portName, int maxBuffers, size_t maxMemory, 
#                 int priority, int stackSize)
URLDriverConfig("$(PORT)", 0, 0)

NDROIConfigure("ROI1", 3, 0, "$(PORT)", 0, 0)
NDStatsConfigure("Stats1", 3, 0, "ROI1", 0, 0)
NDTimeSeriesConfigure("Stats1_TS", 100, 0, "ROI1", 0, 22, 0, 0, 0, 0)
NDStdArraysConfigure("Image1", 3, 0, "ROI1", 0, 0)
NDPvaConfigure("PVA1", 3, 0, "ROI1", 0, "$(PREFIX)PVA1:IMAGE", 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## This waveform 
##  TYPE=Int8,FTVL=UCHAR for 8 bit integer
##  TYPE=Int32,FTVL=LONG for 32 bit integer
##  TYPE=Float32,FTVL=FLOAT,DATATYPE=8 for 32 bit float

dbLoadRecords("$(ADURL)/db/URLDriver.template","P=$(PREFIX),R=CAM1:,PORT=$(PORT),ADDR=0,TIMEOUT=1,ENABLED=1")

dbLoadRecords("NDROI.template", "P=$(PREFIX),R=ROI1:,  PORT=ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),ENABLED=1")

## This waveform allows transporting 16-bit images
## though we are using 8 bit images, epics waveform does not have unsigned types
## and it confuses CS STudio less is we use use 16 bit to keep numbers positive
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=IMAGE1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=ROI1,TYPE=Int16,FTVL=SHORT,NELEMENTS=12582912,ENABLED=1")

dbLoadRecords("NDStats.template", "P=$(PREFIX),R=STATS1:,PORT=Stats1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=ROI1,TYPE=Int16,FTVL=SHORT,ENABLED=1,NCHANS=1,XSIZE=1,YSIZE=1,HIST_SIZE=1")

dbLoadRecords("NDPva.template",  "P=$(PREFIX),R=PVA1:, PORT=PVA1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=ROI1,ENABLED=1")

set_requestfile_path("$(ADURL)/urlApp/Db")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

## The IOC requires the url for single image access as it will poll 
## e.g. for axis camera http://ipaddr/axis-cgi/jpg/image.cgi

dbpf "$(PREFIX)CAM1:URL1", "$(URL1=)"
dbpf "$(PREFIX)CAM1:URL2", "$(URL2=)"
dbpf "$(PREFIX)CAM1:URL3", "$(URL3=)"
dbpf "$(PREFIX)CAM1:URL4", "$(URL4=)"
