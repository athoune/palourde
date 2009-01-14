#!/bin/sh

sudo rm -r /Library/Palourde

export CFLAGS='-O0 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch ppc -arch i386 -mmacosx-version-min=10.5'
export CPPFLAGS='-I/opt/local/include -isysroot /Developer/SDKs/MacOSX10.5.sdk'
export CXXFLAGS='-O2 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch ppc -arch i386 -mmacosx-version-min=10.5'
export MACOSX_DEPLOYMENT_TARGET='10.5'
export CPP='/usr/bin/cpp-4.0'
export CXX='/usr/bin/g++-4.0'
export F90FLAGS='-O2'
export LDFLAGS='-L/opt/local/lib -arch ppc -arch i386 -mmacosx-version-min=10.5'
export FCFLAGS='-O2'
export OBJC='/usr/bin/gcc-4.0' 
export INSTALL='/usr/bin/install -c'
export OBJCFLAGS='-O2' 
export FFLAGS='-O2' 
export CC='/usr/bin/gcc-4.0'

RESOURCES='/Library/Palourde/Palourde.app/Contents/Resources'
BUILD='build/Release/Palourde.app/Contents/Resources'
PWD=`pwd`
cd clamav-src && ./configure --enable-static --with-zlib=/opt/local --with-libbz2-prefix=/opt/local  --with-iconv --with-libgmp-prefix=/opt/local --prefix=/Library/Palourde/Palourde.app/Contents/Resources --disable-clamav --disable-dependency-tracking --sysconfdir=/Library/Preferences/ --with-dbdir=/Library/Palourde/Definitions/ && make clean && make all && sudo make install
cd ..
echo `pwd`
cp -rv $RESOURCES/bin $BUILD/
cp -rv $RESOURCES/include $BUILD/
cp -rv $RESOURCES/lib $BUILD/
cp -rv $RESOURCES/sbin $BUILD/

