# While I don't really want all the libraries required to build
# gtsam, I have to get >90% of them anyhow just to have cmake
# run so that I can tell it to make the docs, so this is probably
# easier.
FROM cntaylor/with-libraries-for-gtsam-python

RUN apt-get -y install doxygen graphviz

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