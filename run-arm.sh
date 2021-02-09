#!/bin/bash

set -euo pipefail

echo "Using CC=${CC:=gcc}"
echo "Using RESULTS_DIR=${RESULTS_DIR:=results}"
echo "Using PADDING_LIST=${PADDING_LIST:=nop mov cmp \
$(python3 microarchitecturometer_generator.py --list-padding aarch64)}"

mkdir -p "$RESULTS_DIR"

for padding in $PADDING_LIST; do
    start=$(date +%s%3N)
    base="microarchitecturometer-$padding"
    echo -ne "Building and running $base.c:\t"
    python3 microarchitecturometer_generator.py mem $padding > "$base.c"
    $CC "$base.c" -O3 -o "$base.out"
    "./$base.out" > "$RESULTS_DIR/$padding.txt"
    echo "DONE in $(($(date +%s%3N) - start)) ms"
done
