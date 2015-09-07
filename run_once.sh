#!/bin/bash

###################################################################
# I had to write this script because the heavy PHP tasks from cron 
# are cloned without having completed.
#
# Scrip usage: <SCRIPTNAME>.sh <HEAVY>.php <HEAVY>.log
# It once run heavy.php and put log into heavy.log
#
# Copyright (C) 2015 Karpychev Evgeniy <shprot@gmail.com> 
# Email:   <shprot@gmail.com>
# Skype:   shprotobaza
# Ln:      https://ru.linkedin.com/pub/karpychev-evgeniy/35/b53/806
#
# License: WTFPL.
###################################################################

# YOU must change it probably.
WORKDIR="/var/www/httpdocs"
LOGDIR="/var/logs/"

# Define VARs.
PHP=$(which php)

# Function print help for script usage.
function print_help {
cat << EOF
Usage: $0 some_file.php log_file.log

Examples:

  $ $0 sendSubscription.php sendSubscription.log
  $ $0 apiFetcher.php apiFetcher.log

Report bugs to ShPRoT
	GitHub:  https://github.com/shprotobaza
	Email:   <shprot@gmail.com>
	Skype:   shprotobaza
EOF
exit 1
}

# Check this - script running or not?
# Exit if running.
function run_once {
SCRIPTNAME=$(basename $0)
local CMD=$1
PIDFILE="/var/run/${SCRIPTNAME}_${CMD}"

if [ -f "$PIDFILE" ] && kill -0 `cat $PIDFILE` 2>/dev/null; then
    echo "Script ${SCRIPTNAME} with command ${CMD} is still running"
    exit 1
fi
echo $$ > $PIDFILE
}

# Function run PHP script defined in $CMD.
# Example: run_command sendSubscription.php sendSubscription.log
function run_command {
local CMD=${1:-ERROR}
local LOG=${2:-ERROR}
# Before run command, check - Is it running?
run_once ${CMD}
# Run command
echo "[--------------------------------[ START: `date +%F--%H-%M` ]--------------------------------]" >> ${LOGDIR}/${LOG}
${PHP} ${WORKDIR}/${CMD} >> ${LOGDIR}/${LOG}
echo "[---------------------------------[ END: `date +%F--%H-%M` ]---------------------------------]" >> ${LOGDIR}/${LOG}
}

# Let's run it!
if [ -z "$1" ]; then print_help ;
else run_command $1 $2
fi

exit 0
