
NDTransformConfigure("AD$(LVDET)RawImage1", 3, 0, "icp", $(LVADDR), 0)
NDROIConfigure("AD$(LVDET)ROI1", 3, 0, "AD$(LVDET)RawImage1", 0, 0)
NDStdArraysConfigure("AD$(LVDET)Image1", 3, 0, "AD$(LVDET)ROI1", 0, 0)
NDStatsConfigure("AD$(LVDET)Stats1", 3, 0, "AD$(LVDET)ROI1", 0, 0)
NDTimeSeriesConfigure("AD$(LVDET)Stats1_TS", 100, 0, "AD$(LVDET)ROI1", 0, 22, 0, 0, 0, 0)
## There is a TEST_areaDetector Kafka topic that can be used for testing
KafkaPluginConfigure("AD$(LVDET)KFK", 3, 1, "AD$(LVDET)RawImage1", 0, -1, "livedata.isis.cclrc.ac.uk:9092", "$(INSTRUMENT=TEST)_areaDetector")
NDPvaConfigure("AD$(LVDET)PVA1", 3, 0, "AD$(LVDET)ROI1", 0, "$(MYPVPREFIX)DAE:AD$(LVDET):pva1:pvadata", 0)

## needs to fit in EPICS_CA_MAX_ARRAY_BYTES i.e. nx * ny * pixelsize
## also NELEMENTS needs to at least nx * ny

## This waveform 
##  TYPE=Int8,FTVL=UCHAR for 8 bit integer
##  TYPE=Int32,FTVL=LONG for 32 bit integer
##  TYPE=Float32,FTVL=FLOAT,DATATYPE=8 for 32 bit float
dbLoadRecords("$(ISISDAE)/db/ADisisdae.template","P=$(MYPVPREFIX),R=DAE:AD$(LVDET):,PORT=icp,ADDR=$(LVADDR),TIMEOUT=1,DATATYPE=8")
dbLoadRecords("NDTransform.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):rawimage1:,PORT=AD$(LVDET)RawImage1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=icp,NDARRAY_ADDR=$(LVADDR),DATATYPE=8,ENABLED=1")
dbLoadRecords("NDROI.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):roi1:,PORT=AD$(LVDET)ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)RawImage1,NDARRAY_ADDR=0,DATATYPE=8,ENABLED=1")
dbLoadRecords("NDStdArrays.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):image1:,PORT=AD$(LVDET)Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=8,ENABLED=1,TYPE=Float32,FTVL=FLOAT,NELEMENTS=$(LIVEVIEW_NELEMENTS=100000),")
dbLoadRecords("NDStats.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):stats1:,PORT=AD$(LVDET)Stats1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=8,ENABLED=1,NCHANS=1,XSIZE=1,YSIZE=1,HIST_SIZE=1")
dbLoadRecords("$(ADPLUGINKAFKA)/db/ADPluginKafka.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):KFK:,PORT=AD$(LVDET)KFK,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)RawImage1,NDARRAY_ADDR=0,DATATYPE=8,ENABLED=1")
dbLoadRecords("NDPva.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):pva1:,PORT=AD$(LVDET)PVA1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,DATATYPE=8,ENABLED=1")

## ffmpegStreamConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr, maxMemory)
#ffmpegStreamConfigure("C$(LVDET).MJPG", 2, 0, "AD$(LVDET)ROI1", 0)
#dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegStream.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):stream1:,PORT=C$(LVDET).MJPG,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,ENABLED=1")

## ffmpegFileConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr)
#ffmpegFileConfigure("C$(LVDET).FILE", 16, 0, "AD$(LVDET)ROI1", 0)
#dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegFile.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):file1:,PORT=C$(LVDET).FILE,ADDR=0,TIMEOUT=1,NDARRAY_PORT=AD$(LVDET)ROI1,NDARRAY_ADDR=0,ENABLED=1")

## 0=none,0x1=err,0x2=IO_device,0x4=IO_filter,0x8=IO_driver,0x10=flow,0x20=warning
#asynSetTraceMask("AD$(LVDET)Image1", -1, 0x11)
