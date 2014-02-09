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
    sudo apt-get install libboost-dev libboost-program-options-dev \
        libboost-thread-dev libboost-system-dev \
        libproj0 proj-bin libproj-dev libtiff-dev libgeotiff-dev \
        libgdal1-dev gdal-bin python-gdal libgdal1 cmake g++
fi

if [ DO_LASZIP ]
then
    sudo mkdir /opt/source
    cd /opt/source
    sudo wget http://download.osgeo.org/laszip/laszip-2.1.0.tar.gz
    sudo tar xvfz laszip-2.1.0.tar.gz
    cd laszip-2.1.0
    sudo cmake -G "Unix Makefiles"
    sudo make -j4
    sudo make install

    echo "Please update the environmental variables for your new library and binary path"
    echo "in .bashrc or profile by addin the following lines:"
    echo "export LD_LIBRARY_PATH=\"$LD_LIBRARY_PATH:/usr/local/lib/\""
    echo "export PATH=\"$PATH:/usr/local/bin/\""
fi

if [ DO_LIBLAS ]
then
    sudo cmake -G "Unix Makefiles" \
      -DWITH_GDAL:BOOL=TRUE -DWITH_LASZIP:BOOL=TRUE -DWITH_GEOTIFF:BOOL=TRUE \
      -DTIFF_INCLUDE_DIR=/usr/include \
      -DTIFF_LIBRARY=/usr/lib/x86_64-linux-gnu/libtiff.so \
      -DGEOTIFF_INCLUDE_DIR=/usr/include/geotiff \
      -DGEOTIFF_LIBRARY=/usr/lib/libgeotiff.so \
      -DGDAL_CONFIG=/usr/bin/gdal-config \
      -DGDAL_INCLUDE_DIR=/usr/include/gdal \
      -DGDAL_LIBRARY=/usr/lib/libgdal1.7.0.so \
      -DLASZIP_INCLUDE_DIR=/usr/local/include/ \
      -DLASZIP_LIBRARY=/usr/local/lib/liblaszip.so

    sudo make -j4
    sudo make install
fi

