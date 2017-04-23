#!/bin/bash

image_NAME='hub:5000/gb-postgres:9.6.2'

docker build --rm -t $image_NAME .

docker push  $image_NAME 

