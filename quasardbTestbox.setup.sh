#!/bin/bash

echo "Invoked with args: $*"

service qdb_httpd stop
mv /etc/qdb/qdb_httpd.conf /etc/qdb/qdb_httpd.conf.orig
qdb_httpd --gen-config --config=/etc/qdb/qdb_httpd.conf.orig $* > /etc/qdb/qdb_httpd.conf
rm /etc/qdb/qdb_httpd.conf.orig
service qdb_httpd start
