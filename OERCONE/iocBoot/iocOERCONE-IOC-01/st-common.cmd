# Set up lua paths for access in the lua shell
epicsEnvSet("LUA_PATH", "${UTILITIES}/lua")
epicsEnvSet("LUA_SCRIPT_PATH","${TOP}/iocBoot/${IOC}")

# Call into the lua shell to boot the ioc
luash("st-common.lua")
