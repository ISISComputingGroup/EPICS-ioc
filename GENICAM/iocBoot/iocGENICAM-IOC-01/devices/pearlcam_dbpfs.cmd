# Enable stuff first so camera has time to process the change
dbpf "$(PREFIX)CAM1:GC_AcqFraRateEnable", "1"
dbpf "$(PREFIX)CAM1:GC_GammaEnable", "1"
dbpf "$(PREFIX)CAM1:GC_SaturationEnable", "1"
dbpf "$(PREFIX)CAM1:GC_BlaLevelSelector", "0"

# set uint16 data type and RGB1 color mode
dbpf "$(PREFIX)CAM1:ColorMode", "RGB1"
dbpf "$(PREFIX)CAM1:DataType", "UInt16"

# Set to 8 bit colour depth - camera can do 16 bit
dbpf "$(PREFIX)CAM1:PixelFormat", "4"
dbpf "$(PREFIX)CAM1:ConvertPixelFormat", "4"

dbpf "$(PREFIX)CAM1:GC_Width", "$(XSIZE)"
dbpf "$(PREFIX)CAM1:GC_Height", "$(YSIZE)"

# Bin so we don't accidentally saturate the network with 24mp of raw mosaiced pixel data...
#epicsEnvSet("BINNINGFACTOR", "1")
#dbpf "$(PREFIX)CAM1:GC_BinningVertical", $(BINNINGFACTOR)
#dbpf "$(PREFIX)CAM1:GC_BinningHorizontal", $(BINNINGFACTOR)

# Bin with Sum - we may need to tweak this. It seems to up exposure, presumably because it's just adding the binned pixels together
#dbpf "$(PREFIX)CAM1:GC_BinVerticalMode", "0"
#dbpf "$(PREFIX)CAM1:GC_BinHorizontalMode", "0"

# Enable constant frame rate mode, then acquire 10hz 
dbpf "$(PREFIX)CAM1:GC_AcqFrameRate", "10"
dbpf "$(PREFIX)CAM1:GC_BalanceWhiteAuto", "2"

dbpf "$(PREFIX)CAM1:GC_Gamma", "0.5"
dbpf "$(PREFIX)CAM1:GC_BlackLevel", "-0.31"
dbpf "$(PREFIX)CAM1:GC_Saturation", "2"
dbpf "$(PREFIX)CAM1:GC_GainAuto", "2"
dbpf "$(PREFIX)CAM1:GC_BalRatioSelector", "0"

dbpf "$(PREFIX)CAM1:GC_ExposureMode", "0"
dbpf "$(PREFIX)CAM1:GC_ExposureAuto", "2"
dbpf "$(PREFIX)CAM1:GC_DevLinThrLimit", "2.63726e+06" 

## overlay crosshair parameters
dbpf "$(PREFIX)OVER1:1:CenterX", $(CROSSHAIR_X=0)
dbpf "$(PREFIX)OVER1:1:CenterY", $(CROSSHAIR_Y=0)
dbpf "$(PREFIX)OVER1:1:SizeX", 5000
dbpf "$(PREFIX)OVER1:1:SizeY", 5000
# seem to need a width of at least 2 to see line in all cases
dbpf "$(PREFIX)OVER1:1:WidthX", 2
dbpf "$(PREFIX)OVER1:1:WidthY", 2
dbpf "$(PREFIX)OVER1:1:Red", 0
dbpf "$(PREFIX)OVER1:1:Green", 255
dbpf "$(PREFIX)OVER1:1:Blue", 0
$(IFCROSSHAIR) dbpf "$(PREFIX)OVER1:1:Use", 1
$(IFNOTCROSSHAIR) dbpf "$(PREFIX)OVER1:1:Use", 0

## set properties on intermediate plugins
dbpf "$(PREFIX)OVER1:ColorMode", "RGB1"
dbpf "$(PREFIX)OVER1:DataType", "UInt16"
dbpf "$(PREFIX)ROI1:ColorMode", "RGB1"
dbpf "$(PREFIX)ROI1:DataType", "UInt16"
dbpf "$(PREFIX)IMAGE1:ColorMode", "RGB1"
dbpf "$(PREFIX)IMAGE1:DataType", "UInt16"

epicsThreadSleep(2.0)
dbpf "$(PREFIX)CAM1:Acquire", "1"
