#!/bin/bash
docker build --no-cache=false -t mosquitto-tls -f Dockerfile .
#podman build --no-cache=true -t mosquitto-tls -f Dockerfile .
