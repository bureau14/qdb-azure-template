#!/bin/bash

echo "Invoked with args: $*"

DEPOT_ROOT='/mnt/db'

while getopts ":a:p:i:n:" OPTNAME; do
    case $OPTNAME in
        a)
            MY_ADDRESS=$OPTARG
            ;;
        p)
            PEER_ADDRESS=$OPTARG
            ;;
        i)
            MY_NODE_INDEX=$OPTARG
            ;;
        n)
            NODE_COUNT=$OPTARG
            ;;
        \?)
            echo "Command line error: unknown option $OPTARG."
            exit 1
            ;;
    esac
done

if [ "$MY_ADDRESS" != "" ]; then
    echo "My address: $MY_ADDRESS"
else
    echo "Command line error: address is missing."
    exit 1
fi

if [ "$PEER_ADDRESS" == "$MY_ADDRESS" ]; then
    echo "Node is its own peer, ignoring."
    PEER_ADDRESS=""
elif [ "$PEER_ADDRESS" != "" ]; then
    echo "Peer address: $PEER_ADDRESS"
else
    echo "No peer specified"
fi

if [ "$MY_NODE_INDEX" != "" ] && [ "$NODE_COUNT" != "" ]; then
    MY_NODE_ID=$(printf "%08X00000000-0000000000000000-0000000000000000-0000000000000001" $((0x100000000 * $MY_NODE_INDEX / $NODE_COUNT)))
    echo "Node Id: $MY_NODE_ID"
else
    echo "Using automatic node id"
fi

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
configure-qdbd 'global.limiter.max_in_entries_count' '99999'

if [ "$PEER_ADDRESS" != "" ]; then
    configure-qdbd 'local.chord.bootstrapping_peers' "[\"$PEER_ADDRESS:2836\"]"
fi

if [ "$MY_NODE_ID" != "" ]; then
    configure-qdbd 'local.chord.node_id' "\"$MY_NODE_ID\""
fi

service qdbd start
