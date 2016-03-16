#/bin/env bash

VERSION=$(git rev-parse --short HEAD)
ZIPFILE="topology-$VERSION.zip"

rm -f $ZIPFILE

7z a $ZIPFILE               \
    createUiDefinition.json \
    jumpbox-*.*             \
    mainTemplate.json       \
    node-*.*                \
    shared-*.*
