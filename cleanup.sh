#!/usr/bin/env bash

set -ex

sudo apt-get clean all

sudo rm -rf /tmp/*
sudo rm -rf /var/chef
sudo rm -rf /vagrant
sudo rm -f /etc/ssh/ssh_host_*
cd /var/log
sudo find /var/log/ -type f -name '*.log' -exec sudo cp /dev/null {} \;
sudo cp /dev/null /var/log/syslog

yes | sudo cp /dev/null /root/.ssh/authorized_keys
yes | sudo cp /dev/null /root/.bash_history
if [ -d /home/ubuntu ]; then
  yes | sudo cp /dev/null /home/ubuntu/.ssh/authorized_keys
  yes | sudo cp /dev/null /home/ubuntu/.bash_history
fi
history -c

