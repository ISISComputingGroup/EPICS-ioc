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
DB_INSTALLS += $(HVCAEN)/db/ai.template
DB_INSTALLS += $(HVCAEN)/db/ao.template
DB_INSTALLS += $(HVCAEN)/db/bi.template
DB_INSTALLS += $(HVCAEN)/db/bo.template
DB_INSTALLS += $(HVCAEN)/db/longin.template
DB_INSTALLS += $(HVCAEN)/db/longout.template
DB_INSTALLS += $(HVCAEN)/db/stringin.template
DB_INSTALLS += $(HVCAEN)/db/stringout.template
DB_INSTALLS += $(HVCAEN)/db/mbbi.template

#----------------------------------------------------
# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_template = <templatename>

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

