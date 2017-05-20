
## GALILNUMCRATES, IFDCM01, IFDCM02 etc. macros set in st.cmd 

$(IFSIM) < motorsim.cmd

# Calculate Galil controller ID within the driver - it starts at 0 whereas GALILCRATE starts at 1
calc("GCID", "0", 2, 2)

$(IFDMC01) epicsEnvSet("GALILCRATE","01")
$(IFDMC01) < galildb.cmd 
$(IFDMC01) $(IFNOTSIM) < $(GALILCONFIG)/galil1.cmd
$(IFDMC01) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC02) epicsEnvSet("GALILCRATE","02")
$(IFDMC02) < galildb.cmd 
$(IFDMC02) $(IFNOTSIM) < $(GALILCONFIG)/galil2.cmd
$(IFDMC02) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC03) epicsEnvSet("GALILCRATE","03")
$(IFDMC03) < galildb.cmd 
$(IFDMC03) $(IFNOTSIM) < $(GALILCONFIG)/galil3.cmd
$(IFDMC03) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC04) epicsEnvSet("GALILCRATE","04")
$(IFDMC04) < galildb.cmd 
$(IFDMC04) $(IFNOTSIM) < $(GALILCONFIG)/galil4.cmd
$(IFDMC04) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC05) epicsEnvSet("GALILCRATE","05")
$(IFDMC05) < galildb.cmd 
$(IFDMC05) $(IFNOTSIM) < $(GALILCONFIG)/galil5.cmd
$(IFDMC05) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC06) epicsEnvSet("GALILCRATE","06")
$(IFDMC06) < galildb.cmd 
$(IFDMC06) $(IFNOTSIM) < $(GALILCONFIG)/galil6.cmd
$(IFDMC06) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC07) epicsEnvSet("GALILCRATE","07")
$(IFDMC07) < galildb.cmd 
$(IFDMC07) $(IFNOTSIM) < $(GALILCONFIG)/galil7.cmd
$(IFDMC07) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC08) epicsEnvSet("GALILCRATE","08")
$(IFDMC08) < galildb.cmd 
$(IFDMC08) $(IFNOTSIM) < $(GALILCONFIG)/galil8.cmd
$(IFDMC08) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC09) epicsEnvSet("GALILCRATE","09")
$(IFDMC09) < galildb.cmd 
$(IFDMC09) $(IFNOTSIM) < $(GALILCONFIG)/galil9.cmd
$(IFDMC09) calc("GCID", "$(GCID) + 1", 2, 2)

$(IFDMC10) epicsEnvSet("GALILCRATE","10")
$(IFDMC10) < galildb.cmd 
$(IFDMC10) $(IFNOTSIM) < $(GALILCONFIG)/galil10.cmd
$(IFDMC10) calc("GCID", "$(GCID) + 1", 2, 2)
