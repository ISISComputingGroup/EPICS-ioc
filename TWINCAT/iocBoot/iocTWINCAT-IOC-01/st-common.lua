package.path = package.path .. ';' .. os.getenv("UTILITIES") .. '/lua/luaUtils.lua;'
ibex_utils = require "luaUtils"

--- Check if a file or directory exists in this path
function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
	   if code == 13 then
		  -- Permission denied, but it exists
		  return true
	   end
	end
	return ok, err
 end
 

function twincat_stcommon_main()
	local motor_port = "L0"
	local num_axes = 8
	local pv_prefix = ibex_utils.getMacroValue{macro="MYPVPREFIX"}
	local tpy_file = ibex_utils.getMacroValue{macro="TPY_FILE"}
	local plc_version = ibex_utils.getMacroValue{macro="PLC_VERSION", default="1"}

	iocsh.tcSetScanRate(150, 2)

	local full_tpy_path = ibex_utils.getMacroValue{macro="ICPCONFIGROOT"} .. "/beckhoff/" .. tpy_file
	if not exists(full_tpy_path) then
		print("invalid TPY file given: " .. full_tpy_path)
		iocsh.exit()
	end
	
	iocsh.tcLoadRecords (full_tpy_path, string.format("-eo -devtc -p %s", pv_prefix))

	iocsh.devMotorCreateController(motor_port, "Controller", num_axes, pv_prefix)

	for axis_num=1,num_axes,1
	do
		motor_pv = string.format("MTR%02i%02i", os.getenv("MTRCTRL"), axis_num)
		single_axis_db = "db/single_axis.db"
		db_args = string.format("MYPVPREFIX=%s,MOTOR_PV=%s,MOTOR_PORT=%s,ADDR=%s", pv_prefix, motor_pv, motor_port, axis_num-1)
		iocsh.devMotorCreateAxis(motor_port, axis_num-1, plc_version)
		iocsh.dbLoadRecords(single_axis_db, db_args)
	end

end

twincat_stcommon_main()
