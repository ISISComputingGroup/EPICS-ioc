## configure galil crate 1

## set crate number (must always be zero padded to 2 digits) - value used below and in galildb.cmd
epicsEnvSet("GALILCRATE","01")

# load database records
< galildb.cmd 

## see README_galil_cmd.txt for command usage

G21X3Config($(GCID),$(GALILADDR$(GALILCRATE)),8,2100,2000) 
#G21X3Config($(GCID),"COM1 115200",8,2100,2000)
#G21X3Config($(GCID),"COM21 115200",8,2100,2000)
#G21X3Config($(GCID),"130.246.51.169",8,2100,2000)
 

G21X3NameConfig($(GCID),"A",0,0,0,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"B",0,0,0,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"C",0,0,0,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"D",0,0,0,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"E",0,0,0,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"F",0,0,0,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"G",0,0,0,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"H",0,0,0,0,0,0,"",0,0,"",1,0)

G21X3StartCard($(GCID),"$(GALIL)/db/galil_Default_Header.gmc;$(GALIL)/db/galil_Piezo_Home.gmc!$(GALIL)/db/galil_Piezo_Home.gmc!$(GALIL)/db/galil_Piezo_Home.gmc!$(GALIL)/db/galil_Piezo_Home.gmc!$(GALIL)/db/galil_Piezo_Home.gmc!$(GALIL)/db/galil_Piezo_Home.gmc!$(GALIL)/db/galil_Piezo_Home.gmc!$(GALIL)/db/galil_Piezo_Home.gmc;$(GALIL)/db/galil_Default_Footer.gmc",0,0)
