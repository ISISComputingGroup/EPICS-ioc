# Set to 8 bit colour mode. Can we convert to 16? 
dbpf "$(PREFIX)CAM1:ColorMode", "2"
# uint16
dbpf "$(PREFIX)CAM1:DataType", "3"
dbpf "$(PREFIX)CAM1:PixelFormat", "4"
dbpf "$(PREFIX)CAM1:ConvertPixelFormat", "4"
dbpf "$(PREFIX)CAM1:GC_Height", "4000"
dbpf "$(PREFIX)CAM1:GC_Width", "5320"

# Bin so we don't accidentally saturate the network with 24mp of raw mosaiced pixel data...
epicsEnvSet("BINNINGFACTOR", "3")
dbpf "$(PREFIX)CAM1:GC_BinningVertical", $(BINNINGFACTOR)
dbpf "$(PREFIX)CAM1:GC_BinningHorizontal", $(BINNINGFACTOR)

# Bin with Sum - we may need to tweak this. It seems to up exposure, presumably because it's just adding the binned pixels together
dbpf "$(PREFIX)CAM1:GC_BinVerticalMode", "0"
dbpf "$(PREFIX)CAM1:GC_BinHorizontalMode", "0"

# Enable constant frame rate mode, then acquire 2hz 
dbpf "$(PREFIX)CAM1:GC_AcqFraRateEnable", "1"
dbpf "$(PREFIX)CAM1:GC_AcqFrameRate", "2"
