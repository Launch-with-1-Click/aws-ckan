#!/usr/bin/env bash

set -ex

CKAN_PKG='python-ckan_2.0_amd64.deb'

# cat <<EOL >> sources.list
# deb http://old-releases.ubuntu.com/ubuntu/ saucy main restricted universe multiverse
# deb http://old-releases.ubuntu.com/ubuntu/ saucy-updates main restricted universe multiverse
# deb http://old-releases.ubuntu.com/ubuntu/ saucy-security main restricted universe multiverse
# deb http://old-releases.ubuntu.com/ubuntu/ saucy-backports main restricted universe multiverse
# deb http://old-releases.ubuntu.com/ubuntu/ saucy-proposed main restricted universe multiverse
# EOL
#
# sudo mv sources.list /etc/apt/

# sudo apt-get update -y
sudo apt-get update -y

sudo apt-get -y install debconf-utils
cat <<EOL | sudo debconf-set-selections
grub-pc grub-pc/install_devices multiselect /dev/vda
grub-pc grub-pc/install_devices_empty boolean false
EOL
sudo apt-get -y upgrade

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales


# Installing CKAN from Source
# http://docs.ckan.org/en/ckan-2.2/install-from-source.html

# Install the required packages

sudo apt-get install -y nginx apache2 libapache2-mod-wsgi python-dev postgresql \
  libpq-dev python-pip python-virtualenv git-core solr-jetty openjdk-6-jdk python-pastescript pwgen

PASSWD=`pwgen 12 1`

# Install CKAN into a Python virtual environment

if [ ! -d /usr/lib/ckan/default ]; then
    sudo install -o ubuntu -g ubuntu -d /usr/lib/ckan/default
fi

chown `whoami` /usr/lib/ckan/default
virtualenv --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.2.4#egg=ckan'
pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt
deactivate
. /usr/lib/ckan/default/bin/activate

# Setup a PostgreSQL database

sudo -u postgres createuser -S -D -R ckan_default
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
echo "ALTER USER ckan_default WITH PASSWORD '$PASSWD';" | sudo -u postgres psql
sudo install -o postgres -g postgres -m 0644 /vagrant/files/pg_hba.conf /etc/postgresql/9.3/main/
sudo service postgresql restart

# Create a CKAN config file

sudo mkdir -p /etc/ckan/default
sudo chown -R www-data /etc/ckan/

cd /usr/lib/ckan/default/src/ckan
paster make-config ckan development.ini
sed -e "s/ckan_default:pass/ckan_default:$PASSWD/" development.ini > production.ini
sudo mv production.ini /etc/ckan/default/production.ini
rm -f development.ini

# Setup Solr (Single Solr instance)

sudo install -o root -g root -m 0644 /vagrant/files/jetty /etc/default/

if [ -f /etc/solr/conf/schema.xml ]; then
    sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
fi

if [ ! -L /etc/solr/conf/schema.xml ]; then
    sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema-2.0.xml /etc/solr/conf/schema.xml
fi

sudo service jetty restart

# Create database tables

cd /usr/lib/ckan/default/src/ckan
paster db init -c /etc/ckan/default/production.ini

# Link to who.ini

sudo ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini


# Create the WSGI Script File
# http://docs.ckan.org/en/ckan-2.2/deployment.html
sudo install -o www-data -g www-data -m 0644 /vagrant/files/apache.wsgi /etc/ckan/default/
sudo install -o www-data -g www-data -m 0644 /vagrant/files/ckan_default.conf /etc/apache2/sites-available/
sudo install -o www-data -g www-data -m 0644 /vagrant/files/ports.conf /etc/apache2/

sudo install -o www-data -g www-data -m 0644 /vagrant/files/ckan_default.nginx /etc/nginx/sites-available/ckan_default
sudo ln -s /etc/nginx/sites-available/ckan_default /etc/nginx/sites-enabled/ckan_default
sudo rm -f /etc/nginx/sites-enabled/default

sudo a2dissite 000-default
sudo a2ensite ckan_default
sudo service apache2 restart
sudo service nginx restart

# echo postfix postfix/main_mailer_type select 'Internet Site' | debconf-set-selections
# echo postfix postfix/mail_name string $HOSTNAME | debconf-set-selections
# apt-get -y install postfix

sudo install -o root -g root -m 0600 /vagrant/files/ckan.cron /etc/cron.d/ckan
sudo install -o root -g root -m 0700 /vagrant/files/reset_ckan_pass.sh /usr/local/bin/

