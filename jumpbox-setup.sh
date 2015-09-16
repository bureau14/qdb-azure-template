#!/bin/bash

echo "Invoked with args: $*"

MY_ADDRESS=$1
PEER_ADDRESS=$2

cd $(dirname $0)

apt-get -y install 'jq' 'python-setuptools' 'php-pear' 'php5-dev' 'libpcre3-dev'
dpkg -i *.deb
easy_install *.egg
pecl install quasardb*.tgz
echo "extension=quasardb.so" > /etc/php5/cli/conf.d/quasardb.ini

function configure-httpd {
    jq ".$1 = $2" /etc/qdb/qdb_httpd.conf > qdb_httpd.conf
    mv -f qdb_httpd.conf /etc/qdb/qdb_httpd.conf
}

configure-httpd 'listen_on' "\"$MY_ADDRESS:8080\""
configure-httpd 'remote_node' "\"$PEER_ADDRESS:2836\""

service qdb_httpd start

mv -f 'jumpbox-motd.txt' '/etc/motd'
