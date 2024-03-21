
NDTransformConfigure("AD$(DIG)$(LVDET)RI1", 3, 0, "DIG$(DIG)", $(LVADDR), 0)
NDROIConfigure("AD$(DIG)$(LVDET)ROI1", 3, 0, "AD$(DIG)$(LVDET)RI1", 0, 0)
NDStdArraysConfigure("AD$(DIG)$(LVDET)IM1", 3, 0, "AD$(DIG)$(LVDET)ROI1", 0, 0)
NDStatsConfigure("AD$(DIG)$(LVDET)ST1", 3, 0, "AD$(DIG)$(LVDET)ROI1", 0, 0)
NDTimeSeriesConfigure("AD$(DIG)$(LVDET)ST1_TS", 100, 0, "AD$(DIG)$(LVDET)ROI1", 0, 22, 0, 0, 0, 0)
NDPvaConfigure("AD$(DIG)$(LVDET)PVA1", 3, 0, "AD$(DIG)$(LVDET)ROI1", 0, "$(MYPVPREFIX)$(IOCNAME):D$(DIG):AD$(LVDET):pva1:pvadata", 0)
NDFileHDF5Configure("AD$(DIG)$(LVDET)FILE", 3, 0, "AD$(DIG)$(LVDET)ROI1", 0, 0, 0, 0)

## needs to fit in EPICS_CA_MAX_ARRAY_BYTES i.e. nx * ny * pixelsize
## also NELEMENTS needs to at least nx * ny

## This waveform 
##  TYPE=Int8,FTVL=UCHAR for 8 bit integer
##  TYPE=Int32,FTVL=LONG for 32 bit integer
##  TYPE=Float32,FTVL=FLOAT,DATATYPE=8 for 32 bit float
##  TYPE=Float64,FTVL=DOUBLE,DATATYPE=9 for 64 bit float
dbLoadRecords("$(NUCINSTDIG)/db/ADNucInstDig.template","P=$(MYPVPREFIX),Q=$(IOCNAME):D$(DIG):,R=$(IOCNAME):D$(DIG):AD$(LVDET):,PORT=DIG$(DIG),ADDR=$(LVADDR),DIG=$(DIG),LVDET=$(LVDET),TIMEOUT=1,ENABLED=1,DATATYPE=$(DATATYPE=9),TYPE=$(TYPE=Float64)")
dbLoadRecords("NDTransform.template", "P=$(MYPVPREFIX),R=$(IOCNAME):D$(DIG):AD$(LVDET):RI1:,PORT=AD$(DIG)$(LVDET)RI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=DIG$(DIG),NDARRAY_ADDR=$(LVADDR),DATATYPE=$(DATATYPE=9),ENABLED=1")
dbLoadRecords("NDROI.template", "P=$(MYPVPREFIX),R=$(IOCNAME):D$(DIG):AD$(LVDET):ROI1:,PORT=AD$(DIG)$(LVDET)ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(DIG)$(LVDET)RI1,NDARRAY_ADDR=0,DATATYPE=$(DATATYPE=9),ENABLED=1")
dbLoadRecords("NDStdArrays.template", "P=$(MYPVPREFIX),R=$(IOCNAME):D$(DIG):AD$(LVDET):IM1:,PORT=AD$(DIG)$(LVDET)IM1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(DIG)$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=$(DATATYPE=9),ENABLED=1,TYPE=$(TYPE=Float64),FTVL=$(FTVL=DOUBLE),NELEMENTS=$(LIVEVIEW_NELEMENTS=1300000)")
dbLoadRecords("NDStats.template", "P=$(MYPVPREFIX),R=$(IOCNAME):D$(DIG):AD$(LVDET):ST1:,PORT=AD$(DIG)$(LVDET)ST1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(DIG)$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=$(DATATYPE=9),ENABLED=1,NCHANS=1,XSIZE=1,YSIZE=1,HIST_SIZE=1")
dbLoadRecords("NDPva.template", "P=$(MYPVPREFIX),R=$(IOCNAME):D$(DIG):AD$(LVDET):PVA1:,PORT=AD$(DIG)$(LVDET)PVA1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(DIG)$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=$(DATATYPE=9),ENABLED=1")
dbLoadRecords("NDFileHDF5.template", "P=$(MYPVPREFIX),R=$(IOCNAME):D$(DIG):AD$(LVDET):FILE:,PORT=AD$(DIG)$(LVDET)FILE,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(DIG)$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=$(DATATYPE=9),ENABLED=1")


## 0=none,0x1=err,0x2=IO_device,0x4=IO_filter,0x8=IO_driver,0x10=flow,0x20=warning
#asynSetTraceMask("AD$(DIG)$(LVDET)IM1", -1, 0x11)
