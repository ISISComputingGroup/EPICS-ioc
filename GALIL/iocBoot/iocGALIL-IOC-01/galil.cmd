
## GALILNUMCRATES, IFDCM01, IFDCM02 etc. macros set in st.cmd 

# In the G21X3Setup command, the parameters are:
#
#    int   number of cards in system
#    int   update rate in Hz whilst motor is moving
G21X3Setup($(GALILNUMCRATES=0),10)

$(IFSIM) < motorsim.cmd

# Calculate Galil controller ID within the driver - it starts at 0 whereas GALILCRATE starts at 1
calc("GCID", "0", 2, 2)

# conditionally load based on how many crates we have
$(IFDMC01) < galil1.cmd
$(IFDMC01) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC02) < galil2.cmd
$(IFDMC02) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC03) < galil3.cmd
$(IFDMC03) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC04) < galil4.cmd
$(IFDMC04) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC05) < galil5.cmd
$(IFDMC05) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC06) < galil6.cmd
$(IFDMC06) calc("GCID", "$(GCID) + 1", 2, 2)
$(IFDMC07) < galil7.cmd
$(IFDMC07) calc("GCID", "$(GCID) + 1", 2, 2)
