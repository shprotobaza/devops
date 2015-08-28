#! /bin/bash

###################################################################
# Automate commands that we use frequently. For DevOps/Admins.
#
# Author:  Karpychev Evgeniy aka ShPRoT
# Email:   <shprot@gmail.com>
# Skype:   shprotobaza
# Ln:      https://ru.linkedin.com/pub/karpychev-evgeniy/35/b53/806
###################################################################

PHP=`which php`
DIR="/var/www/<PROJECT_DIR>"
ENV="prod"

function show_help () {
# Show help usage this script
        echo "Usge: ${0##*/} <filename> cache|elastic";
        exit 1;
}

function cache_clear () {
# Symfony2 cache clear.
        ${PHP} -d memory_limit=-1 ${DIR}/app/console cache:clear --env=${ENV}
}

function elastic_reindex () {
# Elasticsearch reindex.
        ${PHP} -d memory_limit=-1 ${DIR}/app/console --env=${ENV} fos:ela:pop
}


case "$1" in
        "") show_help;;
        cache) cache_clear;;
        elastic) elastic_reindex;;
        *) show_help;;
esac
