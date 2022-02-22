#!/bin/bash

ROOT_DIR=$(pwd)

#---------------------------------------------------
# Build QMaxSAT
#---------------------------------------------------
cd $ROOT_DIR/tools/qmaxsatpb

# Untar archives
tar xvzf minisat-2.2.0.tar.gz
mkdir qmaxsat
tar xvzf qmaxsat-v0-1.tgz 
mv 0.1 mtl qmaxsat
rm LICENSE README

# Delete unneeded build files
rm qmaxsat/0.1/*.o
rm qmaxsat/0.1/*.or
rm qmaxsat/0.1/qmaxsat_static
rm minisat/core/Main.cc
rm minisat/core/Solver.cc

# Merge
cp -rf qmaxsat/mtl minisat
cp -rf qmaxsat/0.1/* minisat/core

# Apply qmaxsat fix patch
cd minisat/core
patch < $ROOT_DIR/patches/qmaxsat_fix.patch

# Build
make

# Copy tool to tools folder
cp qmaxsat $ROOT_DIR/tools/qmaxsat
chmod +x $ROOT_DIR/tools/qmaxsat

#---------------------------------------------------
# Build QMaxSATpb
#---------------------------------------------------
cd $ROOT_DIR/tools/qmaxsatpb/minisat 

# Apply proof logging patch
patch -p1 < $ROOT_DIR/patches/prooflogging.patch

# Build
cd core
make

# Copy tool to tools folder
cp qmaxsat $ROOT_DIR/tools/qmaxsat_prooflogging
chmod +x $ROOT_DIR/tools/qmaxsat_prooflogging

# Cleanup
rm -rf $ROOT_DIR/tools/qmaxsatpb/minisat $ROOT_DIR/tools/qmaxsatpb/qmaxsat

#---------------------------------------------------
# Build VeriPB
#---------------------------------------------------
cd $ROOT_DIR/tools/veripb

# Untar archive
unrar x -ad veripb.rar 

# Apply WCNF patch
cd veripb
patch -p1 < $ROOT_DIR/patches/veripb_wcnf.patch

# Install
pip3 install ./

# Clean up
rm -rf $ROOT_DIR/tools/veripb/veripb

#---------------------------------------------------
# Build VeriPB
#---------------------------------------------------
cd $ROOT_DIR/tools/limiter

# Untar archive
tar xvzf runlim-1.10.tar.gz 

# Build
cd runlim-1.10
./configure.sh && make

# Copy tool to tools folder
cp runlim $ROOT_DIR/tools
chmod +x $ROOT_DIR/tools

# Cleanup
rm -rf $ROOT_DIR/tools/limiter/runlim-1.10