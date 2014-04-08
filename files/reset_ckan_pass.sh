#!/usr/bin/env bash

set -ex

PASSWD=`pwgen 12 1`

echo "ALTER USER ckan_default WITH PASSWORD '$PASSWD';" | sudo -u postgres psql
install -o postgres -g postgres -m 0644 /vagrant/files/pg_hba.conf /etc/postgresql/9.1/main/
service postgresql restart

sed -e "s/ckan_default:pass/ckan_default:$PASSWD/" /etc/ckan/default/development.ini > /etc/ckan/default/production.ini

sudo service jetty restart
service apache2 restart
service nginx restart

rm -f /etc/cron.d/ckan
