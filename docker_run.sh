#!/bin/bash
echo ${STY}
docker run --rm --gpus all \
  --name ${@:1} \
  -v /home/terada/work/NeRF-SLAM:/home/terada/work/NeRF-SLAM \
  -v /home/terada/MegaDepth_v1_SfM:/dataset/MegaDepth_v1_SfM \
  -v /mnt:/mnt:shared \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  --env STY=$STY \
  --net host \
  --shm-size=1024m \
  -it 'nerf-slam:latest' bash
