#!/bin/bash

MACHINES=$(julia -e 'using BinaryBuilder; println(join(triplet.(supported_platforms()), " "))')
VERSIONS="4.9.4 6.1.0 7.1.0 8.1.0"

for m in $MACHINES; do
    for v in $VERSIONS; do
        julia --color=yes build_tarballs.jl --gcc-version $v $m
    done
done
