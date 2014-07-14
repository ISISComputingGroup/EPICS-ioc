
## GALILNUMCRATES, IFDCM01, IFDCM02 etc. macros set in st.cmd 

# In the G21X3Setup command, the parameters are:
#
#    int   number of cards in system
#    int   update rate in Hz whilst motor is moving
G21X3Setup($(GALILNUMCRATES=0),10)

$(IFSIM) < motorsim.cmd

# Calculate Galil controller ID within the driver - it starts at 0 whereas GALILCRATE starts at 1
calc("GCID", "0", 2, 2)

$(IFDMC01) epicsEnvSet("GALILCRATE","01")
$(IFDMC01) < galildb.cmd 
$(IFDMC01) < $(GALILCONFIG)/galil1.cmd
$(IFDMC01) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC02) epicsEnvSet("GALILCRATE","02")
$(IFDMC02) < galildb.cmd 
$(IFDMC02) < $(GALILCONFIG)/galil2.cmd
$(IFDMC02) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC03) epicsEnvSet("GALILCRATE","03")
$(IFDMC03) < galildb.cmd 
$(IFDMC03) < $(GALILCONFIG)/galil3.cmd
$(IFDMC03) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC04) epicsEnvSet("GALILCRATE","04")
$(IFDMC04) < galildb.cmd 
$(IFDMC04) < $(GALILCONFIG)/galil4.cmd
$(IFDMC04) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC05) epicsEnvSet("GALILCRATE","05")
$(IFDMC05) < galildb.cmd 
$(IFDMC05) < $(GALILCONFIG)/galil5.cmd
$(IFDMC05) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC06) epicsEnvSet("GALILCRATE","06")
$(IFDMC06) < galildb.cmd 
$(IFDMC06) < $(GALILCONFIG)/galil6.cmd
$(IFDMC06) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC07) epicsEnvSet("GALILCRATE","07")
$(IFDMC07) < galildb.cmd 
$(IFDMC07) < $(GALILCONFIG)/galil7.cmd
$(IFDMC07) calc("GCID", "$(GCID) + 1", 2, 2)
