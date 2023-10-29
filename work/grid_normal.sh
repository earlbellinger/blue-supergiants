#!/bin/bash
#source ~/projects/shmesa/shmesa.sh

export OMP_NUM_THREADS=8

INLIST="inlist_normal"
OUTPUT="grid_normal"
mkdir $OUTPUT

single () {
    local M=$1
    local os=$2
    local Z=$3
    
    PARAMS="os_"$os"-Z_"$Z
    echo "Running mass $M" with $PARAMS
    DIRECTORY=$OUTPUT/"M_"$M"-"$PARAMS 
    if [ -d "$DIRECTORY" ]; then echo 'skipping'; return 0; fi
    
    cp -R template $DIRECTORY 
    cd $DIRECTORY 
    
    shmesa change $INLIST overshoot_f $os
    shmesa change $INLIST overshoot_f0 $(awk "BEGIN {print $os / 10}")
    shmesa change $INLIST new_Y $(awk "BEGIN {print 0.24 + 2*$Z}")
    shmesa change $INLIST new_Z $Z
    shmesa change $INLIST Zbase $Z
    shmesa change $INLIST initial_mass $M
    ./star $INLIST | tee star.out
    
    rm star
    rm -rf photos
    
    cd -
}

for Z in 0.02; do
    for os in 0.335 0.7; do
        for M in `seq 10 20`; do
            single $M $os $Z
        done
    done
done

