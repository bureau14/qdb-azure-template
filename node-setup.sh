#!/bin/bash

echo "Invoked with args: $*"

MY_ADDRESS=$1
PEER_ADDRESS=$2
DEPOT_ROOT='/mnt/db'

cd $(dirname $0)

apt-get update
apt-get -y install jq
dpkg -i *.deb
mv '/var/lib/qdb/db' "$DEPOT_ROOT"            

function configure-qdbd {
    jq ".$1 = $2" /etc/qdb/qdbd.conf > qdbd.conf
    mv -f qdbd.conf /etc/qdb/qdbd.conf
}

configure-qdbd 'local.network.listen_on' "\"$MY_ADDRESS:2836\""
configure-qdbd 'global.depot.root' "\"$DEPOT_ROOT\""
configure-qdbd 'global.limiter.max_in_entries_count' '999999'

if [ "$PEER_ADDRESS" != "" ]; then
    configure-qdbd 'local.chord.bootstrapping_peers' "[\"$PEER_ADDRESS:2836\"]"
fi

service qdbd start
