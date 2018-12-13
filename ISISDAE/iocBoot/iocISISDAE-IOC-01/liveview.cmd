
NDTransformConfigure("AD$(LVDET)RawImage1", 3, 0, "icp", $(LVADDR), 0)
NDROIConfigure("AD$(LVDET)ROI1", 3, 0, "AD$(LVDET)RawImage1", 0, 0)
NDStdArraysConfigure("AD$(LVDET)Image1", 3, 0, "AD$(LVDET)ROI1", 0, 0)
NDStatsConfigure("AD$(LVDET)Stats1", 3, 0, "AD$(LVDET)ROI1", 0, 0)
  
## needs to fit in EPICS_CA_MAX_ARRAY_BYTES i.e. nx * ny * pixelsize
## also NELEMENTS needs to at least nx * ny
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES",  "1100000")

## This waveform 
##  TYPE=Int8,FTVL=UCHAR for 8 bit integer
##  TYPE=Int32,FTVL=LONG for 32 bit integer
##  TYPE=Float32,FTVL=FLOAT,DATATYPE=6 for 32 bit float 
dbLoadRecords("$(ISISDAE)/db/ADisisdae.template","P=$(MYPVPREFIX),R=DAE:AD$(LVDET):,PORT=icp,ADDR=$(LVADDR),TIMEOUT=1,DATATYPE=6")
dbLoadRecords("NDTransform.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):rawimage1:,PORT=AD$(LVDET)RawImage1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=icp,NDARRAY_ADDR=$(LVADDR),DATATYPE=6,ENABLED=1")
dbLoadRecords("NDROI.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):roi1:,PORT=AD$(LVDET)ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)RawImage1,NDARRAY_ADDR=0,DATATYPE=6,ENABLED=1")
dbLoadRecords("NDStdArrays.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):image1:,PORT=AD$(LVDET)Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=6,ENABLED=1,TYPE=Float32,FTVL=FLOAT,NELEMENTS=100000,")
dbLoadRecords("NDStats.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):stats1:,PORT=AD$(LVDET)Stats1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=6,ENABLED=1,NCHANS=1,XSIZE=1,YSIZE=1,HIST_SIZE=1")

## ffmpegStreamConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr, maxMemory)
#ffmpegStreamConfigure("C$(LVDET).MJPG", 2, 0, "AD$(LVDET)ROI1", 0)
#dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegStream.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):stream1:,PORT=C$(LVDET).MJPG,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,ENABLED=1")

## ffmpegFileConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr)
#ffmpegFileConfigure("C$(LVDET).FILE", 16, 0, "AD$(LVDET)ROI1", 0)
#dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegFile.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):file1:,PORT=C$(LVDET).FILE,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,ENABLED=1")

#NDPvaConfigure("PVA$(LVDET)", 3, 0, "AD$(LVDET)ROI1", 0, "v4pvname$(LVDET)")
#dbLoadRecords("NDPva.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):pva1:,PORT=PVA$(LVDET),ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,ENABLED=1")

## 0=none,0x1=err,0x2=IO_device,0x4=IO_filter,0x8=IO_driver,0x10=flow,0x20=warning
#asynSetTraceMask("AD$(LVDET)Image1", -1, 0x11)
