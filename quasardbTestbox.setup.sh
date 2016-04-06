#!/bin/bash

echo "Invoked with args: $*"

cd $(dirname $0)

apt-get update
apt-get -y install 'python-setuptools' 'php-pear' 'php5-dev' 'libpcre3-dev'
dpkg -i *.deb
tar xvf qdb-benchmark-*.tar.gz -C /usr
easy_install *.egg
pecl install quasardb*.tgz
echo "extension=quasardb.so" > /etc/php5/cli/conf.d/quasardb.ini

service qdb_httpd stop
mv /etc/qdb/qdb_httpd.conf /etc/qdb/qdb_httpd.conf.orig
qdb_httpd --gen-config --config=/etc/qdb/qdb_httpd.conf.orig $* > /etc/qdb/qdb_httpd.conf
rm /etc/qdb/qdb_httpd.conf.orig
service qdb_httpd start

mv -f 'quasardbTestbox.motd.txt' '/etc/motd'
