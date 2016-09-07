#!/bin/bash

echo "Invoked with args: $*"

service qdb_httpd stop
sleep 5
mv /etc/qdb/qdb_httpd.conf /etc/qdb/qdb_httpd.conf.orig
qdb_httpd --gen-config --config=/etc/qdb/qdb_httpd.conf.orig $* > /etc/qdb/qdb_httpd.conf
rm -f /etc/qdb/qdb_httpd.conf.orig
rm -f /var/log/qdb_http/*
service qdb_httpd start
