# Get the base Ubuntu image from Docker Hub.
# Trying out jammy (22.04)
FROM ubuntu:jammy

# Disable GUI prompts
ENV DEBIAN_FRONTEND noninteractive

# Update apps on the base image
RUN apt-get -y update && apt-get -y install

# Install C++, cmake, and apt-utils
# apt-utils is requires for libtbb...
RUN apt-get -y install build-essential cmake apt-utils

# Install (just the required) boost and cmake
# This list of boost comes cmake/HandleBoost.cmake in the
# gtsam repository
# Using just the required makes the Docker image about 300MBytes smaller
# (and builds quicker to boot)
RUN apt-get -y install libboost-serialization-dev \
    libboost-system-dev libboost-filesystem-dev \
    libboost-thread-dev libboost-program-options-dev \
    libboost-date-time-dev libboost-timer-dev \
    libboost-chrono-dev libboost-regex-dev

# Install TBB
RUN apt-get -y install libtbb-dev

# Install git
RUN apt-get -y install git

# Install pip
RUN apt-get install -y python3-pip python3-dev

# Note that these two libraries are actually pulled
# from /usr/src/gtsam/python/requirements.txt after
# download.  I want it to be added before
# the git pull though.  If things break later on,
# may need to modify this list
# Previous command:
# RUN python3 -m pip install -U -r /usr/src/gtsam/python/requirements.txt
RUN python3 -m pip install numpy pyparsing

#With these packages, can run Jupyter-like things in VS code, 
#giving us graphics/plots from within the Docker container
# ipython is not strictly necessary, but I sure like it there
RUN python3 -m pip install matplotlib pylint ipykernel && \
    python3 -m pip install ipython
