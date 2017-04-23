#!/bin/bash

image_NAME='hub:5000/gb-redis:3.2.8'

docker build --rm -t $image_NAME .

docker push  $image_NAME 
