
NDTransformConfigure("AD$(ID)$(LVDET)RawImage1", 3, 0, "$(PORT)", $(LVADDR), 0)
NDROIConfigure("AD$(ID)$(LVDET)ROI1", 3, 0, "AD$(ID)$(LVDET)RawImage1", 0, 0)
NDStdArraysConfigure("AD$(ID)$(LVDET)Image1", 3, 0, "AD$(ID)$(LVDET)ROI1", 0, 0)
NDStatsConfigure("AD$(ID)$(LVDET)Stats1", 3, 0, "AD$(ID)$(LVDET)ROI1", 0, 0)
NDTimeSeriesConfigure("AD$(ID)$(LVDET)Stats1_TS", 100, 0, "AD$(ID)$(LVDET)ROI1", 0, 22, 0, 0, 0, 0)
NDPvaConfigure("AD$(ID)$(LVDET)PVA1", 3, 0, "AD$(ID)$(LVDET)ROI1", 0, "$(P)$(Q)AD$(LVDET):pva1:pvadata", 0)
NDFileHDF5Configure("AD$(ID)$(LVDET)FILE", 3, 0, "AD$(ID)$(LVDET)ROI1", 0, 0, 0, 0)

## needs to fit in EPICS_CA_MAX_ARRAY_BYTES i.e. nx * ny * pixelsize
## also NELEMENTS needs to at least nx * ny

## This waveform 
##  TYPE=Int8,FTVL=UCHAR for 8 bit integer
##  TYPE=Int32,FTVL=LONG,DATATYPE=4 for 32 bit integer
##  TYPE=Float32,FTVL=FLOAT,DATATYPE=8 for 32 bit float
##  TYPE=Float64,FTVL=DOUBLE,DATATYPE=9 for 64 bit float
dbLoadRecords("$(CAENMCA)/db/ADCAENMCA.template","P=$(MYPVPREFIX),R=$(Q)AD$(LVDET):,PORT=$(PORT),ADDR=$(LVADDR),TIMEOUT=1,ENABLED=1,DATATYPE=4,TYPE=Int32")
dbLoadRecords("NDTransform.template", "P=$(P),R=$(Q)AD$(LVDET):RAWIMAGE1:,PORT=AD$(ID)$(LVDET)RawImage1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=$(LVADDR),DATATYPE=4,ENABLED=1")
dbLoadRecords("NDROI.template", "P=$(P),R=$(Q)AD$(LVDET):ROI1:,PORT=AD$(ID)$(LVDET)ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(ID)$(LVDET)RawImage1,NDARRAY_ADDR=0,DATATYPE=4,ENABLED=1")
dbLoadRecords("NDStdArrays.template", "P=$(P),R=$(Q)AD$(LVDET):IMAGE1:,PORT=AD$(ID)$(LVDET)Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(ID)$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=4,ENABLED=1,TYPE=Int32,FTVL=LONG,NELEMENTS=$(LIVEVIEW_NELEMENTS=5000000),")
dbLoadRecords("NDStats.template", "P=$(P),R=$(Q)AD$(LVDET):STATS1:,PORT=AD$(ID)$(LVDET)Stats1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(ID)$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=4,ENABLED=1,NCHANS=1,XSIZE=1,YSIZE=1,HIST_SIZE=1")
dbLoadRecords("NDPva.template", "P=$(P),R=$(Q)AD$(LVDET):PVA1:,PORT=AD$(ID)$(LVDET)PVA1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(ID)$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=4,ENABLED=1")
dbLoadRecords("NDFileHDF5.template", "P=$(P),R=$(Q)AD$(LVDET):FILE:,PORT=AD$(ID)$(LVDET)FILE,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(ID)$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=4,ENABLED=1")

## 0=none,0x1=err,0x2=IO_device,0x4=IO_filter,0x8=IO_driver,0x10=flow,0x20=warning
#asynSetTraceMask("AD$(ID)$(LVDET)Image1", -1, 0x11)
