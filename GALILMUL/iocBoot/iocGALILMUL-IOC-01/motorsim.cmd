## 8 real axes and 8 CS axes
## the cs axes shoudlbe dealt with another way, but just creating real axes
## stops lots of error messages
motorSimCreateController("$(GALIL_MTR_PORT=GalilSim)", 16)

motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 0, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 1, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 2, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 3, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 4, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 5, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 6, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 7, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 8, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 9, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 10, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 11, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 12, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 13, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 14, 32000, -32000,  0, 0)
motorSimConfigAxis("$(GALIL_MTR_PORT=GalilSim)", 15, 32000, -32000,  0, 0)

## configure galil crate

## passed parameters
##   GCID - galil crate software index. Numbering starts at 0 - will always be 0 if there is one to one galil crate <-> galil IOC mapping
##   GALILADDR - address of this galil

## see README_galil_cmd.txt for usage of commands below

GalilCreateController("$(GALIL_PORT=Galil)", "127.0.0.1", 20)

GalilCreateAxis("$(GALIL_PORT=Galil)","A",0,"",1)
GalilCreateAxis("$(GALIL_PORT=Galil)","B",0,"",1)
GalilCreateAxis("$(GALIL_PORT=Galil)","C",0,"",1)
GalilCreateAxis("$(GALIL_PORT=Galil)","D",0,"",1)
GalilCreateAxis("$(GALIL_PORT=Galil)","E",0,"",1)
GalilCreateAxis("$(GALIL_PORT=Galil)","F",0,"",1)
GalilCreateAxis("$(GALIL_PORT=Galil)","G",0,"",1)
GalilCreateAxis("$(GALIL_PORT=Galil)","H",0,"",1)

GalilCreateCSAxes("$(GALIL_PORT=Galil)")

GalilStartController("$(GALIL_PORT=Galil)","$(GALIL)/gmc/galil_Default_Header.gmc;$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc;$(GALIL)/gmc/galil_Default_Footer.gmc",0,0,3)

GalilCreateProfile("$(GALIL_PORT=Galil)", 2000)
