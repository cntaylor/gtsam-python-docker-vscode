# This container is a multi-stage build with 3 possible end states:
# - Release (GTSAM, with Python, built in Release mode)
# - Debug (GTSAM, with Python, built in Debug mode)
# - Docs (This is a container that (a) builds the docs and (b) runs a webserver to serve the docs)
# (Note that these are in reverse order in the file below so that the "default" is Release)
#
# It builds up in intermediate stages as follows:
# 1. Get all the libraries needed for GTSAM to run with Python
# 2. Clone GTSAM (develop branch)
# 3. Do one of the three end-states above

################################################################
# Build the first intermediate state (get all the libraries to compile and run GTSAM with Python)
# Get the base Ubuntu image from Docker Hub.  Use "jammy" because after that it starts complaining about using pip
FROM ubuntu:jammy AS libraries-for-gtsam-python

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
# pylint not working when convert to apt-get install stuff...

################################################################
# Build the second intermediate state (get all the libraries to compile and run GTSAM with Python)

FROM libraries-for-gtsam-python AS gtsam-downloaded

WORKDIR /usr/src
RUN git clone --single-branch --branch develop https://github.com/borglab/gtsam.git

################################################################
# Build the "Docs" end state

FROM gtsam-downloaded AS docs
RUN apt-get -y install doxygen graphviz

# Change to build directory. Will be created automatically.
WORKDIR /usr/src/gtsam/build
# Run cmake
RUN cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DGTSAM_WITH_EIGEN_MKL=OFF \
    -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF \
    -DGTSAM_BUILD_TIMING_ALWAYS=OFF \
    -DGTSAM_BUILD_TESTS=OFF \
    -DGTSAM_BUILD_PYTHON=ON \
    -DGTSAM_PYTHON_VERSION=3\
    .. \
    && make doc

# Docs are all there.  Now to create a webserver to let people
# see it
RUN apt-get install -y apache2

# Put the docs where apache can find it...
RUN rm -r  /var/www/html && cp -r /usr/src/gtsam/doc/html /var/www

# Start the webserver
EXPOSE 80 
CMD ["apache2ctl", "-D", "FOREGROUND"]

################################################################
# Build the "Debug" end state
FROM gtsam-downloaded AS debug

# Change to build directory. 
WORKDIR /usr/src/gtsam/build
# Run cmake
RUN cmake \
    # Can switch the following to Debug if you need to "step into" GTSAM libraries
    -DCMAKE_BUILD_TYPE=Debug \
    -DGTSAM_WITH_EIGEN_MKL=OFF \
    -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF \
    -DGTSAM_BUILD_TIMING_ALWAYS=OFF \
    -DGTSAM_BUILD_TESTS=OFF \
    -DGTSAM_BUILD_PYTHON=ON \
    -DGTSAM_PYTHON_VERSION=3\
    ..

# Build and install gtsam code
RUN make -j4 install && make -j4 python-install && make clean

# Needed to link with GTSAM
ENV LD_LIBRARY_PATH /usr/local/lib

CMD ["bash"]

################################################################
# Build the "Release" end state
FROM gtsam-downloaded AS release

# Change to build directory. 
WORKDIR /usr/src/gtsam/build
# Run cmake
RUN cmake \
    # Can switch the following to Debug if you need to "step into" GTSAM libraries
    -DCMAKE_BUILD_TYPE=Release \
    -DGTSAM_WITH_EIGEN_MKL=OFF \
    -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF \
    -DGTSAM_BUILD_TIMING_ALWAYS=OFF \
    -DGTSAM_BUILD_TESTS=OFF \
    -DGTSAM_BUILD_PYTHON=ON \
    -DGTSAM_PYTHON_VERSION=3\
    ..

# Build and install gtsam code
RUN make -j4 install && make -j4 python-install && make clean

# Needed to link with GTSAM
ENV LD_LIBRARY_PATH /usr/local/lib

CMD ["bash"]

