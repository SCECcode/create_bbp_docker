#!/bin/sh
docker build . -f Dockerfile -t bbp_min:08132007 --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g)
