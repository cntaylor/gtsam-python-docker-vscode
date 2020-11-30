FROM cntaylor/with-libraries-for-gtsam-python

# Clone GTSAM (develop branch)
WORKDIR /usr/src
RUN git clone --single-branch --branch develop https://github.com/borglab/gtsam.git

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
    ..

# Build and install gtsam code
RUN make -j4 install && make -j4 python-install && make clean

# Needed to link with GTSAM
ENV LD_LIBRARY_PATH /usr/local/lib

CMD ["bash"]