package.path = package.path .. ';' .. os.getenv("UTILITIES") .. '/lua/luaUtils.lua;'
ibex_utils = require "luaUtils"

-- Check a given file exists on disk. 
function exists(file)
	local f=io.open(file,"r")
    if f~=nil then io.close(f) return true else return false end
 end
 
-- Main function called by st-common.cmd
function twincat_stcommon_main()
	local motor_port = "L0"
	local pv_prefix = ibex_utils.getMacroValue{macro="MYPVPREFIX"}
	local tpy_file = ibex_utils.getMacroValue{macro="TPY_FILE"}
	local ioc_name = ibex_utils.getMacroValue{macro="IOCNAME"}
	local plc_version = ibex_utils.getMacroValue{macro="PLC_VERSION", default="1"}
	-- Set TcIoc's scan rate to 150ms for ADS and 300ms for EPICS - this is to avoid ADS fields not updating in channel access quickly enough. 
	iocsh.tcSetScanRate(150, 2)

	local full_tpy_path = ibex_utils.getMacroValue{macro="TWINCATCONFIG"} .. "/" .. tpy_file
	if not exists(full_tpy_path) then
		print("invalid TPY file given: " .. full_tpy_path)
		iocsh.exit()
	end

	local ioc_prefix = pv_prefix .. ioc_name .. ":"
	
	-- iocsh.tcLoadRecords(full_tpy_path, string.format("-eo -devtc -p %s", ioc_prefix))
	local handle = io.popen('\\instrument\\dev\\pytcioc\\venv\\scripts\\activate && python \\instrument\\dev\\pytcioc\\main.py')
	local result = handle:read("*a")


	-- count BENABLEs to determine how many Axes a Beckhoff is using
	-- iocsh.countdbgrep("AXES_NUM", "*ASTAXES_*:STCONTROL-BENABLE*")
	local num_axes = 9
	local mtrctrl = os.getenv("MTRCTRL")

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
