#!/usr/bin/env bash

DIR=$(dirname $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ))
BINDIR="$1.mcsema"

mkdir $BINDIR

# Copy the binary to a temporary file.
BIN="$BINDIR/$(basename $1)"
cp $1 $BIN
chmod a+x $BIN
CXX=$(which c++)

LDLIBS=$(ldd ${BIN} | grep -o -P '/.* ' | tr '\n' ' ')

# Convert the binary into a CFG file.
echo "Decoding"
IDALOG=$BINDIR/decode.log $DIR/scripts/ida_get_cfg.sh $BIN

# Convert the CFG file into a bitcode file.
echo "Lifting"
$DIR/scripts/cfg_to_bc.sh $BIN &> $BINDIR/convert.log

echo "Optimizing"
$DIR/build/llvm-3.5/bin/opt -O3 -o=${BIN}.opt.bc ${BIN}.bc &> $BINDIR/opt.log

echo "Compiling"
$DIR/build/llvm-3.5/bin/llc -filetype=obj -o=${BIN}.o ${BIN}.opt.bc &> $BINDIR/compile.log

echo "Linking"
$CXX -g3 -m64 -std=gnu++11 -I${DIR} ${BIN}.o $DIR/drivers/ELF_64_linux.cpp $LDLIBS -o ${BIN}.lifted -lpthread &> $BINDIR/link.log

echo "Done! Produced ${BIN}.lifted"
