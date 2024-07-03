#!/bin/bash
docker build --target docs -t cntaylor/gtsam-doc .
docker run -d -p 8888:80 cntaylor/gtsam-doc