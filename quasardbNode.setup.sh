#!/bin/bash

echo "Invoked with args: $*"

service qdbd stop
sleep 5
mv /etc/qdb/qdbd.conf /etc/qdb/qdbd.conf.orig
qdbd --gen-config --config=/etc/qdb/qdbd.conf.orig $* > /etc/qdb/qdbd.conf
rm -f /etc/qdb/qdbd.conf.orig
rm -f /var/log/qdb/*
service qdbd start
