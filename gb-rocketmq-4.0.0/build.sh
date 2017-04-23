#!/bin/bash

image_NAME='hub:5000/gb-rocketmq:4.0.0'

docker build --rm -t $image_NAME .

docker push  $image_NAME 
