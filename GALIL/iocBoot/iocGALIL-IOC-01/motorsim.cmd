## 8 real axes and 8 CS axes
## the cs axes shoudlbe dealt with another way, but just creating real axes
## stops lots of error messages
motorSimCreateController("GalilSim", 16)

motorSimConfigAxis("GalilSim", 0, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 1, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 2, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 3, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 4, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 5, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 6, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 7, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 8, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 9, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 10, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 11, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 12, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 13, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 14, 32000, -32000,  0, 0)
motorSimConfigAxis("GalilSim", 15, 32000, -32000,  0, 0)

## configure galil crate

## passed parameters
##   GCID - galil crate software index. Numbering starts at 0 - will always be 0 if there is one to one galil crate <-> galil IOC mapping
##   GALILADDR - address of this galil

## see README_galil_cmd.txt for usage of commands below

GalilCreateController("Galil", "127.0.0.1", 20)

GalilCreateAxis("Galil","A",0,"",1)
GalilCreateAxis("Galil","B",0,"",1)
GalilCreateAxis("Galil","C",0,"",1)
GalilCreateAxis("Galil","D",0,"",1)
GalilCreateAxis("Galil","E",0,"",1)
GalilCreateAxis("Galil","F",0,"",1)
GalilCreateAxis("Galil","G",0,"",1)
GalilCreateAxis("Galil","H",0,"",1)

GalilCreateCSAxes("Galil")

GalilStartController("Galil","$(GALIL)/gmc/galil_Default_Header.gmc;$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc!$(GALIL)/gmc/galil_Piezo_Home.gmc;$(GALIL)/gmc/galil_Default_Footer.gmc",0,0,3)

GalilCreateProfile("Galil", 2000)
