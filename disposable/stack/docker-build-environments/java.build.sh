#!/bin/bash

gradle_zip="gradle-3.3-bin.zip"

if [ ! -f tmp/$gradle_zip ]; then
	mkdir -p tmp
	wget -O tmp/$gradle_zip https://services.gradle.org/distributions/$gradle_zip 
fi

docker build -f java.dockerfile -t gvasko/buildnode-java:latest .

