#!/bin/sh
docker run -it --ulimit stack=-1 --mount type=bind,source="$(pwd)"/target,destination=/app/target bbp_19_8:211206
