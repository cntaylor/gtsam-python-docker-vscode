#!/bin/bash
docker build --target release -t cntaylor/gtsam-python .
docker build --target debug -t cntaylor/gtsam-python-debug .