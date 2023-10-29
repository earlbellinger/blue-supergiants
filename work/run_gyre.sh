#!/bin/bash


find "grid_normal/M_17-os_0.335-Z_0.02/" -name "*.GYRE" | while read filepath; do
    dir=$(dirname "$filepath")
    file=$(basename "$filepath")
    echo "cd $dir && echo $dir/$file && ../../gyre6freqs-ad.sh -i $file -t 1"
done | xargs -I {} -P 12 bash -c "{}"

exit 1

find grid_merge -name "*.GYRE" | while read filepath; do
    dir=$(dirname "$filepath")
    file=$(basename "$filepath")
    echo "cd $dir && echo $dir/$file && ../../gyre6freqs-ad.sh -i $file -t 1"
done | xargs -I {} -P 12 bash -c "{}"


