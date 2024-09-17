
##
## Run this on LXC Guest
##

## Make sure ZoneMinder works
ZM_INSTALLED_VERS=$(curl http://localhost/zm/api/host/getVersion.json -q 2>/dev/null|grep version|cut -d'"' -f4|cut -d'.' -f1-2)
echo -e "INSTALLED: ${ZM_INSTALLED_VERS}"
