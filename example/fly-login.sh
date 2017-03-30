#!/bin/bash

ROOT_ADDRESS=${1:-192.168.100.4}
TARGET=${2:-nonprod}

fly -t $TARGET login -c http://${ROOT_ADDRESS}:8080