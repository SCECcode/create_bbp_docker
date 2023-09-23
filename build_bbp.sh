#!/bin/sh
docker build -f Dockerfile . -t bbp_22_4 --no-cache=true --progress=plain --build-arg APP_UNAME=`id -u -nr` --build-arg APP_GRPNAME=`id -g -nr` --build-arg APP_UID=`id -u` --build-arg APP_GID=`id -g`
