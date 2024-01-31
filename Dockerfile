# from nvidia/cuda:11.3.1-cudnn8-runtime
# FROM nvidia/cuda:11.3.1-devel-ubuntu20.04
FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

RUN apt update -y
RUN apt upgrade -y
# python3.8
RUN apt install -y python3
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN apt install -y git
RUN apt install -y wget
RUN apt install -y python3-distutils
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

# NeRF SLAM setup

## CUDA 11.3
RUN pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113

## change directory (to adapt to your environment)
WORKDIR /home/terada/work/NeRF-SLAM
RUN apt install -y python3-dev
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY ./thirdparty/gtsam/python/requirements.txt ./thirdparty/gtsam/python/requirements.txt
RUN pip install -r ./thirdparty/gtsam/python/requirements.txt

RUN apt install -y openssl libssl-dev
## X11
RUN apt install -y libx11-dev libxrandr-dev libvulkan-dev glslang-dev libxinerama-dev libxcursor-dev libxi-dev libglew-dev
RUN DEBIAN_FRONTEND=noninteractive apt install -y libboost-all-dev 
RUN apt update -y
RUN apt install -y libtbb-dev

## cmake
RUN apt-get update -y
RUN apt install -y cmake

COPY ./thirdparty ./thirdparty/
RUN cmake ./thirdparty/instant-ngp -B build_ngp
RUN cmake --build build_ngp --config RelWithDebInfo -j

##
RUN apt install -y libeigen3-dev
#RUN cmake ./thirdparty/gtsam -DGTSAM_BUILD_PYTHON=1 -DGTSAM_USE_SYSTEM_EIGEN=ON -B build_gtsam 
#RUN cmake --build build_gtsam --config RelWithDebInfo -j
#RUN cd build_gtsam && make python-install