#!/bin/bash
#source ~/projects/shmesa/shmesa.sh
#PATH=$PATH:~/projects/shmesa

export OMP_NUM_THREADS=8

INLIST="inlist_merge"
OUTPUT="grid_merge"
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
	#local bkp="grid_merge2/$MPARAM"
	#echo $bkp
	#if [ -d $bkp ]; then echo 'copying'; cp -R $bkp $OUTPUT; return 0; fi
	
	cp -R template $DIRECTORY 
	
	cd $DIRECTORY 
	
	local MODEL="'../../models/"$PARAMS".model'"
	shmesa change $INLIST relax_composition_filename $MODEL
	#shmesa change $INLIST  initial_z $Z
	shmesa change $INLIST  Zbase $Z
	shmesa change $INLIST  initial_mass $M
	./star $INLIST | tee star.out
	
	rm star
	rm -rf photos
	
	cd -
}

# for linhao
#mc=0.3
#mg=0
#Ye=0.28
#Z=0.008
#M=15
#merger $M $mc $mg $Ye $Z
#exit 1 

mc=0.3
mg=0.3
Ye=0.28
Z=0.02
M=15
for Miter in 14 15 16; do
	merger $Miter $mc $mg $Ye $Z
done
for mciter in 0.25 0.3 0.35; do
	merger $M $mciter $mg $Ye $Z
done
for mgiter in 0 0.15 0.3; do
	merger $M $mc $mgiter $Ye $Z
done
for Yeiter in 0.28 0.31 0.34; do
	merger $M $mc $mg $Yeiter $Z
done

## grid for HR diagram 
mc=0.3
mg=0
Ye=0.28
Z=0.02
for M in `seq 10 20`; do
	merger $M $mc $mg $Ye $Z
done

exit 1 

## grid varied in all parameters
for Z in 0.02 0.008; do
	for M in 10 15 20; do
		for mc in 0.25 0.3 0.35; do
			for mg in 0 0.15 0.3; do
				for Ye in 0.28 0.31 0.35; do
					merger $M $mc $mg $Ye $Z
				done
			done
		done
	done
done

exit 1

## grid varied in all parameters
for Z in 0.02 0.008; do
	for M in 10 15 20; do
		for mc in 0.1 0.2 0.3; do
			for mg in 0 0.15 0.3; do
				for Ye in 0.28 0.31 0.35; do
					merger $M $mc $mg $Ye $Z
				done
			done
		done
	done
done

exit 1

## grid for HR diagram 
mc=0.3
mg=0
Ye=0.28
Z=0.02
for M in `seq 10 20`; do
	merger $M $mc $mg $Ye $Z
done

## initial grid varied in all parameters 
for Z in 0.02 0.008; do
	for M in 10 15 20; do
		for mc in 0.1 0.3 0.5; do
			for mg in 0 0.25 0.5; do
				for Ye in 0.28 0.35 0.5; do
					merger $M $mc $mg $Ye $Z
				done
			done
		done
	done
done

