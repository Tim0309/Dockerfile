#!/bin/bash

image_NAME='hub:5000/centos-redis'

docker build --rm -t $image_NAME .

#docker push  $image_NAME 
