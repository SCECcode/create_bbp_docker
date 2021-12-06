#!/bin/sh
# docker build . -f Dockerfile -t bbp_min:08132157 --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)
docker build --no-cache=true -f Dockerfile . -t bbp_19_8:211205 --build-arg APP_UNAME=`id -u -nr` --build-arg APP_GRPNAME=`id -g -nr` --build-arg APP_UID=`id -u` --build-arg APP_GID=`id -g`
