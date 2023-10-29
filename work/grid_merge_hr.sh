#!/bin/bash
source ~/projects/shmesa/shmesa.sh

export OMP_NUM_THREADS=8

INLIST="inlist_merge"
OUTPUT="grid_merge_hr"
mkdir $OUTPUT

merger () {
    local M=$1
    local mc=$2
    local mg=$3
    local Ye=$4
    local Z=$5
    
    PARAMS="mc_"$mc"-mg_"$mg"-Ye_"$Ye"-Z_"$Z
    echo "Running mass $M" with $PARAMS
    local MPARAM="M_"$M"-"$PARAMS 
    local DIRECTORY=$OUTPUT/$MPARAM
    
    if [ -d "$DIRECTORY" ]; then echo 'skipping'; return 0; fi
    local bkp="grid_merge_hr2/$MPARAM"
    echo $bkp
    if [ -d $bkp ]; then echo 'copying'; cp -R $bkp $OUTPUT; return 0; fi
    
    cp -R template $DIRECTORY 
    
    cd $DIRECTORY 
    
    local MODEL="'../../models/"$PARAMS".model'"
    mesa change $INLIST relax_composition_filename $MODEL
    mesa change $INLIST Zbase $Z
    mesa change $INLIST initial_mass $M
    mesa change $INLIST write_pulse_data_with_profile ".false."
    mesa change $INLIST write_profiles_flag ".false."
    ./star $INLIST | tee star.out
    
    rm star
    rm -rf photos
    
    cd -
}

## grid varied in all parameters
for Z in 0.02; do
    for M in 10 15 20; do
        for mc in 0.2 0.25 0.3 0.35 0.4; do
            for mg in 0 0.15 0.3; do
                for Ye in 0.28 0.35 0.42; do
                    merger $M $mc $mg $Ye $Z
                done
            done
        done
    done
done

