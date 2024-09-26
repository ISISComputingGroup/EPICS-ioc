# Use this line for a specific camera by serial number, in this case a BlackFlyS GigE
epicsEnvSet("CAMERA_ID", "24135412")

# if we don't need controls we might not need to use this. if you try to, you get a load of null pointer exceptions
epicsEnvSet("GENICAM_DB_FILE", "$(ADGENICAM)/db/PGR_BlackflyS_16S2C.template")

# Really large queue so we can stream to disk at full camera speed
epicsEnvSet("QSIZE",  "20000")   
# The maximim image width; used for row profiles in the NDPluginStats plugin
epicsEnvSet("XSIZE",  "1440")
# The maximim image height; used for column profiles in the NDPluginStats plugin
epicsEnvSet("YSIZE",  "1080")
# The maximum number of time series points in the NDPluginStats plugin
epicsEnvSet("NCHANS", "2048")
# The maximum number of frames buffered in the NDPluginCircularBuff plugin
epicsEnvSet("CBUFFS", "500")
# The search path for database files
# This is for Windows
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db;$(ADGENICAM)/db;$(ADSPINNAKER)/db")
# Define NELEMENTS to be enough for a 1440x1080x3 (color) image
epicsEnvSet("NELEMENTS", "4665600")

# ADSpinnakerConfig(const char *portName, const char *cameraId, int traceMask, int memoryChannel,
#                   size_t maxMemory, int priority, int stackSize)
ADSpinnakerConfig("$(PORT)", $(CAMERA_ID), 0x1, 0)
## Overlay Changes
NDOverlayConfigure("OVER1", 3, 0, "$(PORT)", 0, 1)
asynSetTraceIOMask($(PORT), 0, 2)


# Main database.  This just loads and modifies ADBase.template
dbLoadRecords("$(ADSPINNAKER)/db/spinnaker.template", "P=$(PREFIX),R=CAM1:,PORT=$(PORT)")
## Overlay Changes
dbLoadRecords("NDOverlay.template", "P=$(PREFIX),R=CAM1:over1:,PORT=OVER1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0,DATATYPE=8,ENABLED=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=CAM1:over1:1:,PORT=OVER1, NAME=OVRL1,SHAPE=1,O=CAM1:over1:,XPOS=1,YPOS=1,XSIZE=1,YSIZE=1,ADDR=0,TIMEOUT=1")

