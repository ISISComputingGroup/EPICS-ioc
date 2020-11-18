epicsEnvSet("COMBINED_HOMING_MODES",0)
epicsEnvSet("NUMBER_HOME_MODES",8)
epicsEnvSet("AXIS_MODE_MULTIPLIER",1)
iocshCmdLoop("< st-axis-homing.cmd", "MN=\$(I)", "I", 1, 8)
