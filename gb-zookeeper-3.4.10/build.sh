#!/bin/bash

image_NAME='hub:5000/gb-zookeeper:3.4.10'


docker build --rm -t $image_NAME .

docker push  $image_NAME 

