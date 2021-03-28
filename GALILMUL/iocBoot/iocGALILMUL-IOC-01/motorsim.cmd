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
