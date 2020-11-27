#!/bin/bash
# Something like git bash, or just follow these commands
cd ubuntu-with-libraries-for-gtsam-python
docker build --no-cache -t cntaylor/with-libraries-for-gtsam-python .

cd ..
./update_gtsam.sh