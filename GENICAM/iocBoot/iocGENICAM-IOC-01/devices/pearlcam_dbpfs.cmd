# Enable stuff first so camera has time to process the change
dbpf "$(PREFIX)CAM1:GC_AcqFraRateEnable", "1"
dbpf "$(PREFIX)CAM1:GC_GammaEnable", "1"
dbpf "$(PREFIX)CAM1:GC_SaturationEnable", "1"
dbpf "$(PREFIX)CAM1:GC_BlaLevelSelector", "0"

# Set to 8 bit colour mode. Can we convert to 16? 
dbpf "$(PREFIX)CAM1:ColorMode", "2"
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

# Enable constant frame rate mode, then acquire 2hz 
dbpf "$(PREFIX)CAM1:GC_AcqFrameRate", "10"
dbpf "$(PREFIX)CAM1:GC_BalanceWhiteAuto", "2"

dbpf "$(PREFIX)CAM1:GC_Gamma", "0.5"
dbpf "$(PREFIX)CAM1:GC_BlackLevel", "-0.31"
dbpf "$(PREFIX)CAM1:GC_Saturation", "2"
dbpf "$(PREFIX)CAM1:GC_GainAuto", "2"
dbpf "$(PREFIX)CAM1:GC_BalRatioSelector", "0"

dbpf "$(PREFIX)CAM1:GC_ExposureMode", "0"
dbpf "$(PREFIX)CAM1:GC_ExposureAuto", "2"

dbpf "$(PREFIX)CAM1:over1:1:Use", "Yes"
dbpf "$(PREFIX)CAM1:over1:1:SizeX", "2"
dbpf "$(PREFIX)CAM1:over1:1:SizeY", "2"
dbpf "$(PREFIX)CAM1:over1:1:WidthX", "2"
dbpf "$(PREFIX)CAM1:over1:1:WidthY", "2"

