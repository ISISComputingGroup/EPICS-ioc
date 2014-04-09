## configure galil crate 5

## set crate number (must always be zero padded to 2 digits) - value used below and in galildb.cmd
epicsEnvSet("GALILCRATE","05")

# load database records
< galildb.cmd 

## see README_galil_cmd.txt for command usage

G21X3Config($(GCID),$(GALILADDR$(GALILCRATE)),8,2100,2000) 

G21X3NameConfig($(GCID),"A",2,0,2,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"B",4,0,2,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"C",2,0,0,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"D",2,0,2,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"E",2,0,2,0,0,0,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"F",4,0,0,0,0,1,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"G",2,0,0,0,0,1,"",0,0,"",1,0)
G21X3NameConfig($(GCID),"H",3,0,0,0,0,1,"",0,0,"",1,0)

#G21X3StartCard($(GCID),"",0,0)
G21X3StartCard($(GCID),"$(GALIL)/db/galil_Default_Header.gmc;$(GALIL)/db/galil_Home_Home.gmc!$(GALIL)/db/galil_Home_Home.gmc!$(GALIL)/db/galil_Home_Home.gmc!$(GALIL)/db/galil_Home_Home.gmc!$(GALIL)/db/galil_Home_Home.gmc!$(GALIL)/db/galil_Home_RevLimit.gmc!$(GALIL)/db/galil_Home_RevLimit.gmc!$(GALIL)/db/galil_Home_Home.gmc;$(GALIL)/db/galil_Default_Footer.gmc",0,0)
