#!/bin/bash

image_NAME='hub:5000/centos-zb'

docker build --rm -t $image_NAME .

#docker push  $image_NAME 
