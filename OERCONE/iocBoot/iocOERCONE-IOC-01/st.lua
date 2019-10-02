-- #!../../bin/windows-x64/OERCONE-IOC-01

-- # You may have to change OERCONE-IOC-01 to something else
-- # everywhere it appears in this file

-- # Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
iocsh.errlogInit2(65536, 256)

-- # envPaths
iocsh.iocshLoad(string.format("%s/dbload.cmd", iocstartup))

-- # cd ${TOP}
os.execute(string.format("cd %s", getMacroValue{macro="TOP"}))

-- # Register all support components
iocsh.dbLoadDatabase("dbd/OERCONE-IOC-01.dbd")
iocsh.OERCONE_IOC_01_registerRecordDeviceDriver("pdbbase")

-- # calling common command file in ioc 01 boot dir
-- # < ${TOP}/iocBoot/iocOERCONE-IOC-01/st-common.cmd
require("st-common.lua")