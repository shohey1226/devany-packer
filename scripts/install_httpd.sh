# install apr
apt install libpcre3 libpcre3-dev libexpat1-dev -y
cd /tmp
wget http://ftp.riken.jp/net/apache//apr/apr-1.6.3.tar.gz
tar zxvf apr-1.6.3.tar.gz
cd apr-1.6.3
./configure --prefix=/opt/devany/apr
make
make install

# install apr-uitl
cd /tmp
wget http://www-eu.apache.org/dist//apr/apr-util-1.6.1.tar.gz
tar zxvf apr-util-1.6.1.tar.gz
cd apr-util-1.6.1
./configure --prefix=/opt/devany/apr-util --with-apr=/opt/devany/apr
make
make install

# install httpd
cd /tmp
wget http://www.us.apache.org/dist//httpd/httpd-2.4.33.tar.gz
tar zxvf httpd-2.4.33.tar.gz
cd httpd-2.4.33
./configure --prefix=/opt/devany/httpd --with-apr=/opt/devany/apr --with-apr-util=/opt/devany/apr-util
make
make install

# prepare configuration
mkdir -p /opt/devany/httpd/conf/conf.d/
