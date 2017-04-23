#!/bin/bash

image_NAME='hub:5000/gb-nginx:1.11.13'

docker build --rm -t $image_NAME .

docker push  $image_NAME 
