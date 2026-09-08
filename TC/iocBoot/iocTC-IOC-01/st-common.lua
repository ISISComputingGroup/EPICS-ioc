package.path = package.path .. ';' .. os.getenv("UTILITIES") .. '/lua/luaUtils.lua;'
ibex_utils = require "luaUtils"

 
-- Main function called by st-common.cmd
function twincat_stcommon_main()
	local motor_port = "L0"
	local pv_prefix = ibex_utils.getMacroValue{macro="MYPVPREFIX"}
	local ioc_name = ibex_utils.getMacroValue{macro="IOCNAME"}
	local plc_version = ibex_utils.getMacroValue{macro="PLC_VERSION", default="1"}
	local ads_port = ibex_utils.getMacroValue{macro="ADS_PORT"}
	local forward_desc = ibex_utils.getMacroValue{macro="FORWARD_DESC", default="0"}
	local forward_velo = ibex_utils.getMacroValue{macro="FORWARD_VELO", default="0"}
	local forward_units = ibex_utils.getMacroValue{macro="FORWARD_UNITS", default="0"}
	local enable_frozen_offsets = ibex_utils.getMacroValue{macro="ALLOW_FROZEN_OFFSETS", default="0"}
	local enable_auto_on_off = ibex_utils.getMacroValue{macro="ENABLE_AUTO_ON_OFF", default="0"}
	local enable_homing = ibex_utils.getMacroValue{macro="ENABLE_HOMING_PVS", default="0"}

	asyn_port = ibex_utils.getMacroValue{macro="PORT"}

	num_axes = ibex_utils.getMacroValue{macro="NUM_AXES"}
	local mtrctrl = os.getenv("MTRCTRL")
	local ioc_prefix = pv_prefix .. ioc_name .. ":"


	iocsh.devMotorCreateController(motor_port, "Controller", num_axes, ioc_prefix)
	
	autosave_file = io.open (ioc_name .. "_built_settings.req", "w")
	
	db_args = string.format("P=%s,Q=MOT:MTR%02i:,AXES_NUM=%s", pv_prefix, mtrctrl, num_axes)
	iocsh.dbLoadRecords("$(MOTOR)/db/motorController.db", db_args)
	
	for axis_num=1,num_axes,1
	do
		local single_axis_tc_args = string.format("P=%s,AXIS_NUM=%s,ADSPORT=%s,PORT=%s", ioc_prefix, axis_num, ads_port, asyn_port)
		iocsh.dbLoadRecords("$(MOTOREXT)/db/single_axis_tc.db", single_axis_tc_args)

		motor_pv = string.format("MTR%02i%02i", mtrctrl, axis_num)

		if forward_desc == "1" then 
			local desc_tc_args = string.format("P=%s,AXIS_NUM=%s,ADSPORT=%s,PORT=%s", ioc_prefix, axis_num, ads_port, asyn_port)
			iocsh.dbLoadRecords("$(MOTOREXT)/db/desc_tc.db", desc_tc_args)
		end

		
		if forward_units == "1" then 
			local units_tc_args = string.format("P=%s,AXIS_NUM=%s,ADSPORT=%s,PORT=%s", ioc_prefix, axis_num, ads_port, asyn_port)
			iocsh.dbLoadRecords("$(MOTOREXT)/db/units_tc.db", units_tc_args)
		end

		if enable_frozen_offsets == "1" then
			local frozen_offsets_db_args = string.format("P=%s,AXIS_NUM=%s,ADSPORT=%s,PORT=%s", ioc_prefix, axis_num, ads_port, asyn_port)
			iocsh.dbLoadRecords("$(MOTOREXT)/db/frozen_offsets.db", frozen_offsets_db_args)
		end

		if enable_homing == "1" then
			local homing_pvs_db_args = string.format("P=%s,AXIS_NUM=%s,ADSPORT=%s,PORT=%s", ioc_prefix, axis_num, ads_port, asyn_port)
			iocsh.dbLoadRecords("$(MOTOREXT)/db/homing_tc.db", homing_pvs_db_args)
		end

		motor_pv = string.format("MTR%02i%02i", mtrctrl, axis_num)

		if enable_auto_on_off == "1" then 
			local auto_on_off_args = string.format("P=%s,AXIS_NUM=%s,ADSPORT=%s,PORT=%s", ioc_prefix, axis_num, ads_port, asyn_port)
			iocsh.dbLoadRecords("$(MOTOREXT)/db/autoonoff.db", auto_on_off_args)
			autoonoff_args = string.format("P=%s,I=%s,AXIS_NUM=%s,MOTOR_PV=%s", pv_prefix, ioc_name, axis_num, motor_pv)
			iocsh.dbLoadRecords("$(TOP)/db/autoonoff.db", autoonoff_args)
			autosave_file:write(string.format("file \"tc_motor_extra.req\" P=%s, M=MOT:%s\n", pv_prefix, motor_pv))
		end

		single_axis_db = "$(TOP)/db/single_axis.db"
		db_args = string.format("MYPVPREFIX=%s,MOTOR_PV=%s,MOTOR_PORT=%s,ADDR=%s", pv_prefix, motor_pv, motor_port, axis_num-1)
		iocsh.devMotorCreateAxis(motor_port, axis_num-1, plc_version)
		iocsh.dbLoadRecords(single_axis_db, db_args)

		status_args = string.format("P=%s,M=MOT:%s,IOCNAME=%s", pv_prefix, motor_pv, ioc_name)
		iocsh.dbLoadRecords("$(MOTOR)/db/motorStatus.db", status_args)

		axis_monitors = "$(TOP)/db/axis_monitors.db"
		axis_monitors_args = string.format("P=%s,I=%s,AXIS_NUM=%s,MOTOR_PV=%s", pv_prefix, ioc_name, axis_num, motor_pv)
		iocsh.dbLoadRecords(axis_monitors, axis_monitors_args)

		if forward_velo == "1" then
			local forward_velo_args = string.format("P=%s,I=%s,AXIS_NUM=%s,MOTOR_PV=%s", pv_prefix, ioc_name, axis_num, motor_pv)
			iocsh.dbLoadRecords("$(TOP)/db/velo_monitor.db", forward_velo_args)		
		end

		autosave_file:write(string.format("file \"motor_settings.req\" P=%s, M=MOT:%s\n", pv_prefix, motor_pv))
		-- wrap around to next MTRCTRL and alias - this is so we can show >8 axes in the IBEX table of motors. 
		-- for example, MTR0109 is also aliased to MTR0201, MTR0110 is aliased to MTR0202, etc.
		if axis_num > 8 then
			alias_args_orig = string.format("$(MYPVPREFIX)MOT:%s(.*)", motor_pv)
			alias_args_aliased = string.format("$(MYPVPREFIX)MOT:MTR%02i%02i\\1", ((axis_num-1)//8) + mtrctrl, (axis_num-1)%8 + 1)
			iocsh.dbAliasRecordsRE(alias_args_orig, alias_args_aliased)
		end
	end
	autosave_file:close()

end

twincat_stcommon_main()
