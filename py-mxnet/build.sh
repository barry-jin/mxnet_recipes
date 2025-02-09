set -x

export MXNET_LIBRARY_PATH=${PREFIX}/lib/libmxnet.so

cd python
$PYTHON setup.py install --with-cython --single-version-externally-managed --record=record.txt

# Delete the copied libmxnet.so and create a relative symlink to $PREFIX/lib/
# The build scripts produce .so even on osx
find ${PREFIX} | grep libmxnet.so | grep -v $PREFIX/lib/libmxnet.so | xargs rm -f
ln -sf ../../../libmxnet.so $SP_DIR/mxnet/libmxnet.so
