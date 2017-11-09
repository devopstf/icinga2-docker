#!/bin/sh

function echo_log {
	DATE='date +%Y/%m/%d:%H:%M:%S'
	echo `$DATE`" $1"
}

#set -o errexit
#set -o nounset

PREFIX=$(dirname $(readlink -f $0))/..

source ${PREFIX}/lib/import_schema.sh
source ${PREFIX}/lib/set_mysql_config.sh
source ${PREFIX}/lib/setup_config.sh

setup_config

import_schema

initfile=/opt/icinga2/init.done
mkdir -p /opt/icinga2

echo_log "Validating the icinga2 configuration first."
if ! icinga2 daemon -C; then
	echo_log "Icinga 2 config validation failed. Stopping the container."
	exit 1
fi

if [ ! -f "${initfile}" ]; then
        echo_log "Enabling icingaweb2 modules."
        mkdir -p /etc/icingaweb2/enabledModules
        
        echo_log "Enabling icingaweb2 modules."
        if [[ -L /etc/icingaweb2/enabledModules/monitoring ]]; then echo "Symlink for /etc/icingaweb2/enabledModules/monitoring exists already...skipping"; else ln -s /usr/share/icingaweb2/modules/monitoring /etc/icingaweb2/enabledModules/monitoring; fi
        if [[ -L /etc/icingaweb2/enabledModules/doc ]]; then echo "Symlink for /etc/icingaweb2/enabledModules/doc exists already...skipping"; else ln -s /usr/share/icingaweb2/modules/doc /etc/icingaweb2/enabledModules/doc; fi
        touch ${initfile}
fi

touch /var/www/html/health

#/usr/sbin/icinga2 daemon -d

exec "$@"

