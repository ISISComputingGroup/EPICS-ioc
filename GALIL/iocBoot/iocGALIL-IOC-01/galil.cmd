
## GALILNUMCRATES, IFDCM01, IFDCM02 etc. macros set in st.cmd 

# In the G21X3Setup command, the parameters are:
#
#    int   number of cards in system
#    int   update rate in Hz whilst motor is moving
G21X3Setup($(GALILNUMCRATES),2)

$(IFSIM) < motorsim.cmd

# conditionally load based on how many crates we have
$(IFDMC01) < galil1.cmd
$(IFDMC02) < galil2.cmd
$(IFDMC03) < galil3.cmd
$(IFDMC04) < galil4.cmd
$(IFDMC05) < galil5.cmd
$(IFDMC06) < galil6.cmd
$(IFDMC07) < galil7.cmd
