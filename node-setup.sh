#!/bin/bash

echo "Invoked with args: $*"

service qdbd stop
mv /etc/qdb/qdbd.conf /etc/qdb/qdbd.conf.orig
qdbd --gen-config --config=/etc/qdb/qdbd.conf.orig $* > /etc/qdb/qdbd.conf
rm /etc/qdb/qdbd.conf.orig
service qdbd start
