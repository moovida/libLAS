# Thanks to:
# http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html
# for saving me lot's of time with dependencies.

set -x

DO_PREINSTALL=true
DO_LASZIP=true
DO_LIBLAS=true

if [ DO_PREINSTALL ]
then
    echo "Install some dependencies"
    sudo apt-get install libboost-dev libboost-program-options1.46-dev \
        libboost-thread1.46-dev libboost-system-dev \
        proj proj-bin proj-data libproj-dev libtiff4-dev libgeotiff-dev \
        libgdal1-dev gdal-bin python-gdal libgdal1-1.7.0
fi

if [ DO_LASZIP ]
then
    sudo -s
    cd /opt/source
    wget http://download.osgeo.org/laszip/laszip-2.1.0.tar.gz
    tar xvfz laszip-2.1.0.tar.gz
    cd laszip-2.1.0
    mkdir build
    mkdir cmake_build
    cd cmake_build
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/source/laszip-2.1.0/build
    make -j4
    make install

    echo "Please update the environmental variables for your new library and binary path"
    echo "in .bashrc or profile by addin the following lines:"
    echo "export LD_LIBRARY_PATH=\"/opt/source/laszip-2.1.0/build/lib:$LD_LIBRARY_PATH\""
    echo "export PATH=\"/opt/source/laszip-2.1.0/build/bin:$PATH\""
fi

if [ DO_LIBLAS ]
then
    cmake -G "Unix Makefiles" \
      -DTIFF_INCLUDE_DIR=/usr/include \
      -DTIFF_LIBRARY=/usr/lib/x86_64-linux-gnu/libtiff.so \
      -DGEOTIFF_INCLUDE_DIR=/usr/include/geotiff \
      -DGEOTIFF_LIBRARY=/usr/lib/libgeotiff.so \
      -DGDAL_CONFIG=/usr/bin/gdal-config \
      -DGDAL_INCLUDE_DIR=/usr/include/gdal \
      -DGDAL_LIBRARY=/usr/lib/libgdal1.7.0.so \
      -DLASZIP_INCLUDE_DIR=/opt/source/laszip-2.1.0/build/include \
      -DLASZIP_LIBRARY=/opt/source/laszip-2.1.0/build/lib/liblaszip.so

    make -j4
    sudo make install
fi

