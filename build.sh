#!/usr/bin/env sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
runtime=$(CDPATH= cd -- "$root/../gbarecomp" && pwd)
toml="$root/../tomlplusplus/include"
build="$root/build-ninja"
args="-S $root -B $build -DCMAKE_BUILD_TYPE=Release -DGBARECOMP_ROOT=$runtime"
if [ -f "$toml/toml.hpp" ]; then
	args="$args -DGBARECOMP_TOMLPP_INCLUDE_DIR=$toml"
fi
cmake $args -G Ninja
cmake --build "$build" --parallel
