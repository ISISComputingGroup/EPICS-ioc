package.path = package.path .. ';' .. os.getenv("UTILITIES") .. '/lua/luaUtils.lua;'
ibex_utils = require "luaUtils"

function twincat_stcommon_main()
	local motor_port = "L0"
	local pv_prefix = ibex_utils.getMacroValue{macro="MYPVPREFIX"}
	local tpy_file = ibex_utils.getMacroValue{macro="TPY_FILE"}
	local ioc_name = ibex_utils.getMacroValue{macro="IOCNAME"}
	local plc_version = ibex_utils.getMacroValue{macro="PLC_VERSION", default="1"}

	iocsh.tcSetScanRate(150, 2)
	iocsh.tcLoadRecords(tpy_file, string.format("-eo -devtc -p %s", pv_prefix))

	iocsh.countdbgrep("AXES_NUM", "*ASTAXES_*:STCONTROL-BENABLE*")

	local num_axes = ibex_utils.getMacroValue{macro="AXES_NUM", default="8"}

	iocsh.devMotorCreateController(motor_port, "Controller", num_axes, pv_prefix)
	
	autosave_file = io.open (ioc_name .. "_settings.req", "w")
	
	for axis_num=1,num_axes,1
	do
		motor_pv = string.format("MTR%02i%02i", os.getenv("MTRCTRL"), axis_num)
		single_axis_db = "db/single_axis.db"
		db_args = string.format("MYPVPREFIX=%s,MOTOR_PV=%s,MOTOR_PORT=%s,ADDR=%s", pv_prefix, motor_pv, motor_port, axis_num-1)
		iocsh.devMotorCreateAxis(motor_port, axis_num-1, plc_version)
		iocsh.dbLoadRecords(single_axis_db, db_args)
		autosave_file:write(string.format("file \"motor_settings.req\" P=%s, M=MOT:%s\n", pv_prefix, motor_pv))
	end
	autosave_file:close()

end

twincat_stcommon_main()
