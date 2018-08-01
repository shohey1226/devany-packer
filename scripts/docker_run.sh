#!/bin/bash

# Handle back up
if [ -f /etc/passwd.org ]; then
  cp /etc/passwd.org /etc/passwd
else
  cp /etc/passwd /etc/passwd.org
fi

if [ -f /etc/shadow.org ]; then
  cp /etc/shadow.org /etc/shadow
else
  cp /etc/shadow /etc/shadow.org
fi

if [ -f /etc/group.org ]; then
  cp /etc/group.org /etc/group
else
  cp /etc/group /etc/group.org
fi

if [ -f /etc/sudoers.org ]; then
  cp /etc/sudoers.org /etc/sudoers
else
  cp /etc/sudoers /etc/sudoers.org
fi


useradd -m -d /home/$USERNAME -s /bin/bash -p $(echo $PASSWORD | openssl passwd -1 -stdin) $USERNAME
chown $USERNAME:$USERNAME /home/$USERNAME 

# Enable user to sudo 
usermod -aG sudo $USERNAME
# no need to ask password
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

htpasswd -cb /opt/devany/httpd/webdav.password $USERNAME $PASSWORD
chown root:$USERNAME  /opt/devany/httpd/webdav.password
chmod 640 /opt/devany/httpd/webdav.password

chmod 644 /opt/devany/httpd/conf/conf.d/proxy.conf
chmod 644 /opt/devany/httpd/conf/conf.d/webdav.conf

# httpd
if [ -f /opt/devany/httpd/conf/httpd.conf.org ]; then
  cp /opt/devany/httpd/conf/httpd.conf.org /opt/devany/httpd/conf/httpd.conf 
else
  cp /opt/devany/httpd/conf/httpd.conf /opt/devany/httpd/conf/httpd.conf.org 
fi
sed -i -e "s|CHANGE_USERNAME_LATER|${USERNAME}|g" /opt/devany/httpd/conf/httpd.conf

# httpd - webdav
if [ -f /opt/devany/httpd/conf/conf.d/webdav.conf.org ]; then
  cp /opt/devany/httpd/conf/conf.d/webdav.conf.org /opt/devany/httpd/conf/conf.d/webdav.conf 
else
  cp /opt/devany/httpd/conf/conf.d/webdav.conf /opt/devany/httpd/conf/conf.d/webdav.conf.org 
fi
sed -i -e "s|CHANGE_USERNAME_LATER|${USERNAME}|g" /opt/devany/httpd/conf/conf.d/webdav.conf

cd $HOME
su -c "/usr/bin/ttyd -c $USERNAME:$PASSWORD -p 8080 /bin/bash &" - $USERNAME
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start ttyd: $status"
  exit $status
fi

/opt/devany/httpd/bin/httpd -DFOREGROUND &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start httpd: $status"
  exit $status
fi

while sleep 30; do
  ps aux |grep ttyd |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep httpd |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited. checking again"
    while sleep 30; do
      ps aux |grep ttyd |grep -q -v grep
      PROCESS_1_STATUS=$?
      ps aux |grep httpd |grep -q -v grep
      PROCESS_2_STATUS=$?
      if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
        echo "One of the processes has already exited agin. exiting.."
        exit 1
      fi
    done  
  fi
done

