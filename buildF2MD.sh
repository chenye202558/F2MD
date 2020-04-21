#!/bin/bash

F2MD_DIR=$(pwd)

#Install f2md dependencies
sudo apt install -y python3-dev python3-pip python3-tk rapidjson-dev

# Build inet
cd ./inet
export INET_ROOT=${F2MD_DIR}/inet
echo $INET_ROOT
export PATH="${INET_ROOT}/bin:${PATH}"
export INET_NED_PATH="${INET_ROOT}/src:${INET_ROOT}/tutorials:${INET_ROOT}/showcases:${INET_ROOT}/examples"
export INET_OMNETPP_OPTIONS="-n ${INET_NED_PATH} --image-path=${INET_ROOT}/images"
export INET_GDB_OPTIONS="-quiet -ex run --args"
export INET_VALGRIND_OPTIONS="-v --tool=memcheck --leak-check=yes --show-reachable=no --leak-resolution=high --num-callers=40 --freelist-vol=4000000"
make makefiles && make -j$(nproc) WITH_OSGEARTH=no MODE=debug && make -j$(nproc) MODE=release all  

# Build veins
cd ${F2MD_DIR}/veins-f2md
./configure && make -j$(nproc) MODE=release all

# Build veins_inet3
cd ${F2MD_DIR}/veins-f2md/subprojects/veins_inet3
./configure && make -j$(nproc) MODE=release all

# Build simulte
cd ${F2MD_DIR}/simulte-f2md
make makefiles && make -j$(nproc) MODE=release all