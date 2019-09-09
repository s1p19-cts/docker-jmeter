#!/bin/bash

JMETER_VERSION="5.1.1"

# Example build line
docker build  --build-arg JMETER_VERSION=${JMETER_VERSION} -t "askxtreme/jmeter:${JMETER_VERSION}" .
