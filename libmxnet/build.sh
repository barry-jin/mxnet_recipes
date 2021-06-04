#!/usr/bin/env bash

set -ex

# Use the OpenMP library already in the environment
rm -rf 3rdparty/openmp/

# Use the MKL-DNN library already in the environment
# rm -rf 3rdparty/mkldnn
# rm -rf include/mkldnn

export OPENMP_OPT=ON
#export JEMALLOC_OPT=ON

if [[ "$OSTYPE" == "darwin"* ]]; then
  export OPENMP_OPT=OFF
  PLATFORM=darwin
  # On macOS, jemalloc defaults to JEMALLOC_PREFIX: 'je_'
  # for which mxnet source code isn't ready yet.
#  export JEMALLOC_OPT=OFF
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PLATFORM=linux
fi

cmake_config=config/distribution/${PLATFORM}_${mxnet_variant_str}.cmake
if [[ ! -f $cmake_config ]]; then
  >&2 echo "Couldn't find cmake config $cmake_config for the current settings."
  exit 1
fi

cp $cmake_config config.mk

rm -rf build
mkdir build
cd build
cmake -GNinja -C $cmake_config ..
ninja

# make install misses this file
mkdir -p ${PREFIX}/bin
cp im2rec ${PREFIX}/bin/

# remove static libs
rm -f ${PREFIX}/lib/libdmlc.a
rm -f ${PREFIX}/lib/libmxnet.a

# remove cmake cruft
rm -rf ${PREFIX}/lib/cmake/dmlc
