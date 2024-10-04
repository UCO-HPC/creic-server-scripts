#!/bin/bash

SOURCE=https://github.com/zyedidia/micro/releases/download/v2.0.14/micro-2.0.14-linux64-static.tar.gz
FOLDER=$(echo $SOURCE | grep -oP "micro-\d+\.\d+\.\d+")

cd /tmp
wget $SOURCE
tar -xvf micro-*-linux64-static.tar.gz
install --owner=root --group=root --mode=755 ./$FOLDER/micro /usr/bin/
