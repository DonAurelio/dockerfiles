#!/usr/bin/env bash
set -e

export DB_DATABASE="${DB_DATABASE:-datacube}"
export DB_HOSTNAME="${DB_HOSTNAME:-localhost}"
export DB_USERNAME="${DB_USERNAME:-datacube}"
export DB_PASSWORD="${DB_PASSWORD:-datacube}"
export DB_PORT="${DB_PORT:-5432}"

# this variables may be changed according with 
# the version of gdal installed (in the base datacube image)
export GDAL_DATA="/usr/share/gdal/2.3"
export PATH="$HOME/.local/bin:$PATH"

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
# Copied from: https://github.com/docker-library/postgres/blob/master/10/docker-entrypoint.sh
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

# First set up the CONF_FILE environment variable
file_env 'DATACUBE_CONFIG_PATH'
if [ "$DATACUBE_CONFIG_PATH" ]; then
    export CONF_FILE="$DATACUBE_CONFIG_PATH"
else 
    export CONF_FILE="$HOME/.datacube.conf"
fi

# Build Config file
echo "[datacube]" > $CONF_FILE 

file_env 'DB_DATABASE'
if [ "$DB_DATABASE" ]; then
    echo "db_database: $DB_DATABASE" >> $CONF_FILE 
else
    echo >&2
    echo >&2 'Warning: missing DB_DATABASE environment variable'
    echo >&2 '*** Using "datacube" as fallback. ***'
    echo >&2
    echo "db_database: datacube" >> $CONF_FILE
fi

file_env 'DB_HOSTNAME'
if [ "$DB_HOSTNAME" ]; then
    echo "db_hostname: $DB_HOSTNAME" >> $CONF_FILE 
fi

file_env 'DB_USERNAME'
if [ "$DB_USERNAME" ]; then
    echo "db_username: $DB_USERNAME" >> $CONF_FILE 
fi

file_env 'DB_PASSWORD'
if [ "$DB_PASSWORD" ]; then
    echo "db_password: $DB_PASSWORD" >> $CONF_FILE
fi

file_env 'DB_PORT'
if [ "$DB_PORT" ]; then
    echo "db_port: $DB_PORT" >> $CONF_FILE
fi

# init postgres database
echo "datacube" | sudo -S su -c " service postgresql restart " root > /dev/null
# start database in startup
echo "datacube" | sudo -S su -c " update-rc.d postgresql enable "  root

# create datacube database user and pasword
echo
echo "*** Create $DB_DATABASE Database ***"
echo "datacube" | sudo -S su -c " echo \"create user $DB_USERNAME with password '$DB_PASSWORD';\" | psql "  postgres
echo "datacube" | sudo -S su -c " echo \"alter user $DB_USERNAME createdb;\" | psql " postgres
echo "datacube" | sudo -S su -c " echo \"alter user $DB_USERNAME createrole;\" | psql " postgres
echo "datacube" | sudo -S su -c " echo \"alter user $DB_USERNAME superuser;\" | psql " postgres
echo "datacube" | sudo -S su -c " echo \"create database $DB_DATABASE;\" | psql " postgres
echo "datacube" | sudo -S su -c " echo \"grant all privileges on database $DB_DATABASE to $DB_USERNAME;\" | psql " postgres

exec "$@"
