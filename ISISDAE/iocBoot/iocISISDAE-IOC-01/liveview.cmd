
dbLoadRecords("$(ISISDAE)/db/ADisisdae.template","P=$(MYPVPREFIX),R=DAE:AD$(LVDET):,PORT=icp,ADDR=$(LVADDR),TIMEOUT=1")

NDStdArraysConfigure("AD$(LVDET)Image1", 3, 0, "icp", $(LVADDR), 0)

## needs to fit in EPICS_CA_MAX_ARRAY_BYTES i.e. nx * ny * pixelsize
## also NELEMENTS needs to at least nx * ny
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES",  "1100000")

## This waveform 
##  TYPE=Int8,FTVL=UCHAR for 8 bit integer
##  TYPE=Int32,FTVL=LONG for 32 bit integer
##  TYPE=Float32,FTVL=FLOAT for 32 bit float
dbLoadRecords("NDStdArrays.template", "P=$(MYPVPREFIX),R=DAE:AD$(LVDET):image1:,PORT=AD$(LVDET)Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=icp,NDARRAY_ADDR=$(LVADDR),TYPE=Float32,FTVL=FLOAT,NELEMENTS=100000,ENABLED=1")

## Create an FFT plugin
#NDFFTConfigure("FFT1", 3, 0, "icp", 0)
#dbLoadRecords("NDFFT.template", "P=$(PREFIX),R=DAE:FFT1:,PORT=FFT1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0,NAME=FFT1,NCHANS=2048")

## this will now need a color conversion plugin?
#ffmpegServerConfigure(8081)
## ffmpegStreamConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr, maxMemory)
#ffmpegStreamConfigure("C1.MJPG", 2, 0, "icp", 0)
#ffmpegStreamConfigure("C2.MJPG", 2, 0, "icp", 1)
#dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegStream.template", "P=$(MYPVPREFIX),R=DAE:AD1:Stream:,PORT=C1.MJPG,ADDR=0,TIMEOUT=1,NDARRAY_PORT=icp,NDARRAY_ADDR=0,ENABLED=1")
#dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegStream.template", "P=$(MYPVPREFIX),R=DAE:AD2:Stream:,PORT=C2.MJPG,ADDR=0,TIMEOUT=1,NDARRAY_PORT=icp,NDARRAY_ADDR=1,ENABLED=1")

## ffmpegFileConfigure(portName, queueSize, blockingCallbacks, NDArrayPort, NDArrayAddr)
#ffmpegFileConfigure("C1.FILE", 16, 0, "icp", 0)
#dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegFile.template", "P=$(MYPVPREFIX),R=DAE:File:,PORT=C1.FILE,ADDR=0,TIMEOUT=1,NDARRAY_PORT=icp,NDARRAY_ADDR=0,ENABLED=1")

#NDPvaConfigure("PVA", 3, 0, "icp", 0, "v4pvname")
#dbLoadRecords("NDPva.template", "P=$(MYPVPREFIX),R=DAE:V4:,PORT=PVA,ADDR=0,TIMEOUT=1,NDARRAY_PORT=icp,NDARRAY_ADDR=0,ENABLED=1")

## 0=none,0x1=err,0x2=IO_device,0x4=IO_filter,0x8=IO_driver,0x10=flow,0x20=warning
#asynSetTraceMask("AD$(LVDET)Image1", -1, 0x11)

