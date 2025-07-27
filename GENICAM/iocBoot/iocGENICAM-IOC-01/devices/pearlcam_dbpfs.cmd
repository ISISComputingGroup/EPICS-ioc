# Enable stuff first so camera has time to process the change
dbpf "$(PREFIX)CAM1:GC_AcqFraRateEnable", "1"
dbpf "$(PREFIX)CAM1:GC_GammaEnable", "1"
dbpf "$(PREFIX)CAM1:GC_SaturationEnable", "1"
dbpf "$(PREFIX)CAM1:GC_BlaLevelSelector", "0"

# Set to 8 bit colour mode. Can we convert to 16? 
#dbpf "$(PREFIX)CAM1:ColorMode", "2"
# uint16
dbpf "$(PREFIX)CAM1:DataType", "3"
dbpf "$(PREFIX)CAM1:PixelFormat", "4"
dbpf "$(PREFIX)CAM1:ConvertPixelFormat", "4"

dbpf "$(PREFIX)CAM1:GC_Height", "1080"
dbpf "$(PREFIX)CAM1:GC_Width", "1440"

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
dbpf "$(PREFIX)OVER1:1:CenterX", 400
dbpf "$(PREFIX)OVER1:1:CenterY", 400
dbpf "$(PREFIX)OVER1:1:SizeX", 5000
dbpf "$(PREFIX)OVER1:1:SizeY", 5000
dbpf "$(PREFIX)OVER1:1:WidthX", 2
dbpf "$(PREFIX)OVER1:1:WidthY", 2
dbpf "$(PREFIX)OVER1:1:Red", 0
dbpf "$(PREFIX)OVER1:1:Green", 255
dbpf "$(PREFIX)OVER1:1:Blue", 0
dbpf "$(PREFIX)OVER1:1:Use", 1

$(IFDEVSIM) dbpf "$(PREFIX)CAM1:ColorMode", "RGB1"
$(IFDEVSIM) dbpf "$(PREFIX)CAM1:DataType", "Int16"
dbpf "$(PREFIX)OVER1:ColorMode", "RGB1"
dbpf "$(PREFIX)OVER1:DataType", "Int16"
dbpf "$(PREFIX)ROI1:ColorMode", "RGB1"
dbpf "$(PREFIX)ROI1:DataType", "Int16"
dbpf "$(PREFIX)IMAGE1:ColorMode", "RGB1"
dbpf "$(PREFIX)IMAGE1:DataType", "Int16"

#dbpf "$(PREFIX)CAM1:Acquire", "1"
