TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

#----------------------------------------------------
#  Optimization of db files using dbst (DEFAULT: NO)
#DB_OPT = YES

#----------------------------------------------------
# Create and install (or just install) into <top>/db
# databases, templates, substitutions like this

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_template = <templatename>

DB += galil_motors.db galil_motor_extras.db galil_dmc_ctrl.db galil_userdef_records8.db 
DB += galil_profileMoveController.db galil_profileMoveAxis.db galil_analog_ports.db 
DB += galil_digital_ports.db galil_user_array.db galil_csmotor_kinematics.db
DB += galil_coordinate_systems.db galil_csmotor_extras.db

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

