#!/bin/bash
cd build-gtsam
docker build --no-cache -t cntaylor/gtsam-experimental .
