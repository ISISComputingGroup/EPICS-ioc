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
DB += galil_motor_withwrappers.db

DB += galil_motor_withoutwrappers.db

DB += galil_motor_extras.db

DB += galil_ctrl_extras.db

DB += galil_digital_ports.db

DB += galil_analog_ports.db

DB += galil_userdef_records.db

#USR_DBFLAGS += -V

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_template = <templatename>

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

