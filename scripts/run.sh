#!/bin/bash

useradd -m -d /home/$USERNAME -s /bin/bash -p $(echo $PASSWORD | openssl passwd -1 -stdin) $USERNAME
chown -R $USERNAME:$USERNAME /home/$USERNAME
echo "export HOME=/home/$USERNAME" >> /home/$USERNAME/.bashrc

# Enable user to sudo 
usermod -aG sudo $USERNAME

htpasswd -cb /etc/apache2/webdav.password $USERNAME $PASSWORD
chown root:$USERNAME /etc/apache2/webdav.password
chmod 640 /etc/apache2/webdav.password

chmod 644 /etc/apache2/sites-available/proxy.conf 
chmod 644 /etc/apache2/sites-available/webdav.conf

mkdir -p /var/tmp/run
mkdir -p /var/tmp/lock/apache2
mkdir -p /var/tmp/log/apache2

chmod 777 -R /var/tmp

# change superviser env variables
sed -i -e "s|CHANGE_USERNAME_LATER|${USERNAME}|" /etc/default/devany.env
sed -i -e "s|CHANGE_PASSWORD_LATER|${PASSWORD}|" /etc/default/devany.env

# Run upervisord
/etc/init.d/supervisor start

