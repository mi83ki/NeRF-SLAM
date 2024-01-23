# from nvidia/cuda:11.3.1-cudnn8-runtime
FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

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
#RUN pip install -r ./thirdparty/gtsam/python/requirements.txt