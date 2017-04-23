#!/bin/bash
image_NAME='hub:5000/gb-tomcat-jre8:7.0.67'

docker build --rm -t $image_NAME .

docker push  $image_NAME 
