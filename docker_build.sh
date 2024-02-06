#!/bin/bash

eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
docker build -t nerf-slam --ssh default .
