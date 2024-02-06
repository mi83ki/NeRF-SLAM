# syntax=docker/dockerfile:1

FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

RUN apt update -y
RUN apt upgrade -y
# python3
RUN apt install -y python3 python3-dev python3-pip build-essential
RUN apt install -y openssl libssl-dev
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN apt install -y git
RUN apt install -y wget
RUN apt install -y python3-distutils


# NeRF SLAM setup
## CUDA 11.3
RUN pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113

## Clone sources
RUN apt install -y openssh-client

ADD .git/index /tmp/dummy
# github.com のための公開鍵をダウンロード
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

## プライベート・リポジトリのクローン
RUN --mount=type=ssh git clone https://github.com/hterada/NeRF-SLAM.git -b dev/docker-build --recurse-submodules
RUN cd NeRF-SLAM && git submodule update --init --recursive

## change directory (to adapt to your environment)
WORKDIR /NeRF-SLAM
RUN pip install -r requirements.txt
RUN pip install -r ./thirdparty/gtsam/python/requirements.txt

## X11
RUN apt install -y libx11-dev 
RUN apt install -y libxrandr-dev libvulkan-dev glslang-dev libxinerama-dev libxcursor-dev libxi-dev libglew-dev
RUN DEBIAN_FRONTEND=noninteractive apt install -y libboost-all-dev 
RUN apt update -y
RUN apt install -y libtbb-dev

## cmake
RUN apt-get update -y
RUN apt install -y cmake
##
RUN pip install colored-glog
RUN apt install -y libglib2.0-0/jammy-updates

## NGP
### change branch
RUN cd ./thirdparty/instant-ngp && git checkout -b feature/nerf_slam origin/feature/nerf_slam
RUN apt-get install -y libopenexr-dev libxi-dev libglfw3-dev libglew-dev libomp-dev libxinerama-dev libxcursor-dev
RUN cmake ./thirdparty/instant-ngp -B build_ngp
RUN cmake --build build_ngp --config RelWithDebInfo -j


## eigen
RUN cd ./thirdparty/eigen && mkdir build && cd build && cmake ..
RUN cd ./thirdparty/eigen && cd build && make install

## GTSAM
RUN cmake ./thirdparty/gtsam -DGTSAM_BUILD_PYTHON=1 -DGTSAM_USE_SYSTEM_EIGEN=ON -B build_gtsam 
RUN cmake --build build_gtsam --config RelWithDebInfo -j
RUN cd build_gtsam && make python-install

## lietorch
RUN cd ./thirdparty/lietorch && python setup.py install
#RUN cd ./thirdparty/lietorch && ./run_tests.sh
#RUN pip install git+https://github.com/princeton-vl/lietorch.git

RUN python setup.py install

