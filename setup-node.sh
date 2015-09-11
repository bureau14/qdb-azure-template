#!/bin/bash

echo "Invoked with args: $*"

cd $(dirname $0)

apt-get -y install jq
dpkg -i *.deb
mv /var/lib/qdb/db /mnt

function configure-qdbd {
    jq ".$1 = $2" /etc/qdb/qdbd.conf > qdbd.conf
    mv -f qdbd.conf /etc/qdb/qdbd.conf
}

while getopts :a:p: OPT; do
    case $OPT in
        a)
            configure-qdbd 'local.network.listen_on' "\"$OPTARG:2836\""
            ;;
        p)
            configure-qdbd 'local.chord.bootstrapping_peers' "[\"$OPTARG:2836\"]"
            ;;
    esac
done

configure-qdbd 'global.depot.root' '"/mnt/db"'
configure-qdbd 'global.limiter.max_in_entries_count' '99999'

service qdbd start
