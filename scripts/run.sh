#!/bin/bash

useradd -m -d /home/$USERNAME -s /bin/bash -p $(echo $PASSWORD | openssl passwd -1 -stdin) $USERNAME
chown -R $USERNAME:$USERNAME /home/$USERNAME
echo "export HOME=/home/$USERNAME" >> /home/$USERNAME/.bashrc

# Enable user to sudo 
usermod -aG sudo $USERNAME
# no need to ask password
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

htpasswd -cb /opt/devany/httpd/webdav.password $USERNAME $PASSWORD
chown root:$USERNAME  /opt/devany/httpd/webdav.password
chmod 640 /opt/devany/httpd/webdav.password

chmod 644 /etc/apache2/sites-available/proxy.conf 
chmod 644 /etc/apache2/sites-available/webdav.conf

# change superviser env variables
sed -i -e "s|CHANGE_USERNAME_LATER|${USERNAME}|" /etc/default/devany.env
sed -i -e "s|CHANGE_PASSWORD_LATER|${PASSWORD}|" /etc/default/devany.env

# ttyd - change user/group with override.conf to bring up with the suer
sed -i -e "s|CHANGE_USERNAME_LATER|${USERNAME}|g" /etc/systemd/system/ttyd.service.d/override.conf

# httpd
sed -i -e "s|CHANGE_USERNAME_LATER|${USERNAME}|g" /opt/devany/httpd/conf/httpd.conf

# httpd - webdav
sed -i -e "s|CHANGE_USERNAME_LATER|${USERNAME}|g" /opt/devany/httpd/conf/conf.d/webdav.conf

# Run systemd
systemctl daemon-reload
systemctl enable httpd
systemctl enable ttyd
systemctl start httpd
systemctl start ttyd
