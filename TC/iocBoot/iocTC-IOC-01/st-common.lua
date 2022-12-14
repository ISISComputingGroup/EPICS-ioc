package.path = package.path .. ';' .. os.getenv("UTILITIES") .. '/lua/luaUtils.lua;'
ibex_utils = require "luaUtils"

 
-- Main function called by st-common.cmd
function twincat_stcommon_main()
	local motor_port = "L0"
	local pv_prefix = ibex_utils.getMacroValue{macro="MYPVPREFIX"}
	-- local tpy_file = ibex_utils.getMacroValue{macro="TPY_FILE"}
	local ioc_name = ibex_utils.getMacroValue{macro="IOCNAME"}
	local plc_version = ibex_utils.getMacroValue{macro="PLC_VERSION", default="1"}
	local ads_port = ibex_utils.getMacroValue{macro="ADS_PORT", default="852"}
	asyn_port = ibex_utils.getMacroValue{macro="PORT"}
	num_axes = 1 -- todo: actually poll the device to get this
	local mtrctrl = os.getenv("MTRCTRL")
	local ioc_prefix = pv_prefix .. ioc_name .. ":"

	for axis_num=1,num_axes,1
	do
		local single_axis_tc_args = string.format("P=%s,A=%s,ADSPORT=%s,PORT=%s", ioc_prefix, axis_num, ads_port, asyn_port)
		iocsh.dbLoadRecords("db/single_axis_tc.db", single_axis_tc_args)
	end


	iocsh.devMotorCreateController(motor_port, "Controller", num_axes, ioc_prefix)
	
	autosave_file = io.open (ioc_name .. "_settings.req", "w")
	
	db_args = string.format("P=%s,Q=MOT:MTR%02i:,AXES_NUM=%s", pv_prefix, mtrctrl, num_axes)
	iocsh.dbLoadRecords("$(MOTOR)/db/motorController.db", db_args)
	
	for axis_num=1,num_axes,1
	do
		motor_pv = string.format("MTR%02i%02i", mtrctrl, axis_num)
		single_axis_db = "db/single_axis.db"
		db_args = string.format("MYPVPREFIX=%s,MOTOR_PV=%s,MOTOR_PORT=%s,ADDR=%s", pv_prefix, motor_pv, motor_port, axis_num-1)
		iocsh.devMotorCreateAxis(motor_port, axis_num-1, plc_version)
		iocsh.dbLoadRecords(single_axis_db, db_args)

		status_args = string.format("P=%s,M=MOT:%s,IOCNAME=%s", pv_prefix, motor_pv, ioc_name)
		iocsh.dbLoadRecords("$(MOTOR)/db/motorStatus.db", status_args)

		axis_monitors = "db/axis_monitors.db"
		axis_monitors_args = string.format("P=%s,I=%s,AXIS_NUM=%s,MOTOR_PV=%s", pv_prefix, ioc_name, axis_num, motor_pv)
		iocsh.dbLoadRecords(axis_monitors, axis_monitors_args)
		autosave_file:write(string.format("file \"motor_settings.req\" P=%s, M=MOT:%s\n", pv_prefix, motor_pv))
		-- wrap around to next MTRCTRL - this is so we can show >8 axes in the IBEX table of motors. 
		if axis_num > 8 then
			alias_args_orig = string.format("$(MYPVPREFIX)MOT:%s(.*)", motor_pv)
			alias_args_aliased = string.format("$(MYPVPREFIX)MOT:MTR%02i%02i\\1", ((axis_num-1)//8) + mtrctrl, (axis_num-1)%8 + 1)
			iocsh.dbAliasRecordsRE(alias_args_orig, alias_args_aliased)
		end
	end
	autosave_file:close()

end

twincat_stcommon_main()
