package.path = package.path .. ';' .. os.getenv("UTILITIES") .. '/lua/luaUtils.lua;'
ibex_utils = require "luaUtils"


function set_up_coms() 
	local device = ibex_utils.getMacroValue{macro="DEVICE", default="L0"}
	local addr = ibex_utils.getMacroValue{macro="PORT", default="hostname:7777"}
	
	if string.find(addr, "COM") then
	  print("COM selected")
	  iocsh.drvAsynSerialPortConfigure(device, addr, 0, 0, 0, 0)
	  local baud = ibex_utils.getMacroValue{macro="BAUD", default="9600"}
	  local bits = ibex_utils.getMacroValue{macro="BITS", default="7"}
	  local parity = ibex_utils.getMacroValue{macro="PARITY", default="odd"}
	  local stop = ibex_utils.getMacroValue{macro="STOP", default="1"}
	  ibex_utils.setHardwareFlowControl{addr, false}
	  ibex_utils.setSoftwareFlowControl{addr, false}
	else
	  print("IP selected")
	  drvAsynIPPortConfigure(device, addr)
	end
end

set_up_coms()
