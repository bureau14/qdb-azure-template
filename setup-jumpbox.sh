#!/bin/bash

echo "Invoked with args: $*"

cd $(dirname $0)

apt-get -y install jq
dpkg -i *.deb

function configure-httpd {
    jq ".$1 = $2" /etc/qdb/qdb_httpd.conf > qdb_httpd.conf
    mv -f qdb_httpd.conf /etc/qdb/qdb_httpd.conf
}

while getopts :a:p: OPT; do
    case $OPT in
        a)
            configure-httpd 'listen_on' "\"$OPTARG:8080\""
            ;;
        p)
            configure-httpd 'remote_node' "\"$OPTARG:2836\""
            ;;
    esac
done

service qdb_httpd start
