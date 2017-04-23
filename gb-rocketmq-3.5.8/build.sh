#!/bin/bash

image_NAME='hub:5000/gb-rocketmq:3.5.8'

docker build --rm -t $image_NAME .

#docker push  $image_NAME 
