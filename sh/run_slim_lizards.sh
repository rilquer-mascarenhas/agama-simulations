#!/bin/bash

TIMESTAMP=`date +"%s"`

echo "TIMESTAMP:" 
echo $TIMESTAMP

## defining arguments!!!
# -B flag # boolean, 0/1, whether or not to add barrier1
# -b flag # boolean, 0/1, whether or not to add barrier2
# -c flag # boolean, 0/1, whether or not to add spatial competition. Reduces K
# -F flag # float, 0-0.5, mean of female dispersal distance
# -f flag # float, 0-0.5, standard deviation of female dispersal distance
# -G flag # integer, what generation to add barrier1
# -g flag # integer, what generation to add barrier2
# -i flag # boolean, 0/1, whether or not to add isolation-by-distance in reproduction
# -M flag # float, 0-0.5, mean of male dispersal distance
# -m flag # float, 0-0.5, standard deviation of male dispersal distance
# -O flag # integer, number of generations to output
# -R flag # string, recombination rate (in scientific notation)
# -U flag # string, mutation rate (in scientific notation)
# -X flag # integer, average number of females mated with per male
# -x flag # float, 0.0-1.0, sex ratio as porportion of females
# -z flag # float, scaling factor (must be above 0)
# -t flag # boolean, 0/1, whether or not to do treesequence recording 
# -N flag # integer, number of simulations
# -T flag # string, output treesequence name
# -s flag # boolean, 0/1, whether to have selection on mitochondria 
# -w flag # float, 0.0-1.0, fixed value of mitochondrial selection strength

while getopts B:b:c:F:f:G:g:i:M:m:O:R:U:X:x:z:t:N:T:s:w: OPTION
do
	case "$OPTION" in
		B)
			echo "The value of -B (whether to add barrier 1) is $OPTARG";
			barrier1=$OPTARG;
			#exit
			;;	
		b)
			echo "The value of -b (whether to add barrier 2) is $OPTARG";
			barrier2=$OPTARG;
			#exit
			;;
		c)
			echo "The value of -c (whether to have spatial comp) is $OPTARG";
			comp=$OPTARG;
			#exit
			;;
		F)
			echo "The value of -F (mean female dispersal) is $OPTARG";
			dispFemale=$OPTARG;
			#exit
			;;
		f)
			echo "The value of -f (stdev female dispersal) is $OPTARG";
			dispDevFemale=$OPTARG;
			#exit
			;;
		G)
			echo "The value of -G (generation to add barrier 1) is $OPTARG";
			barrier1gen_un=$OPTARG;
			#exit
			;;
		g)
			echo "The value of -g (generation to add barrier 2) is $OPTARG";
			barrier2gen_un=$OPTARG;
			#exit
			;;
		i)
			echo "The value of -i (isolation by distance toggle) is $OPTARG";
			ibd=$OPTARG;
			#exit
			;;
		M)
			echo "The value of -M (mean male dispersal) is $OPTARG";
			dispMale=$OPTARG;
			#exit
			;;
		m)
			echo "The value of -m (stdev male dispersal) is $OPTARG";
			dispDevMale=$OPTARG;
			#exit
			;;
		O)
			echo "The value of -O (output generation) is $OPTARG";
			outputGen_un=$OPTARG;
			#exit
			;;
		R)
			echo "The value of -R (recombination rate) is $OPTARG";
			recomb_un=$OPTARG;
			#exit
			;;
		U)
			echo "The value of -U (mutation rate) is $OPTARG";
			mu_un=$OPTARG;
			#exit
			;;
		X)
			echo "The value of -s (females per male mated with) is $OPTARG";
			females_per_male=$OPTARG;
			#exit
			;;
		x)
			echo "The value of -S (sex ratio) is $OPTARG";
			sexRatio=$OPTARG;
			#exit
			;;
		z)
			echo "The value of -z (scaling factor) is $OPTARG";
			scaling=$OPTARG;
			#exit
			;;
		t)
			echo "The value of -t (treeSequence recording) is $OPTARG";
			treeSeq=$OPTARG;
			#exit
			;;
		N)
			echo "The value of -N (number of simulations) is $OPTARG";
			simulations=$OPTARG;
			#exit
			;;
		T)
			echo "The value of -T (treesequence name) is $OPTARG";
			treeName=$OPTARG;
			#exit
			;;
		s)
			echo "The value of -s (mitochondrial selection toggle) is $OPTARG";
			mtSelect=$OPTARG;
			#exit
			;;
		w)
			echo "The value of -w (mitochondrial selection fitness parameter) is $OPTARG";
			selStrength=$OPTARG;
			#exit
			;;
	esac
done

echo
echo "Beginning ${simulations} runs"
echo

for ((i=1;i<=simulations;i++)); do ## for run in simulations runs

	echo
	echo "#####"
	echo $i
	echo "#####"
	echo
	
	## for each iteration of slim,
	echo "Running SLiM"
	#slim $script;

	## string together all of the commands with -d, the only thing you need to do is toggle if theta or not 
	## note: you can pass extra constants to SLiM even if they aren't called by SLIM
	
	## THIS ONLY WORKS WITH SINGLE FILENAMES

	command="/home/kprovost/nas5/LIZARD_SLIM/build/slim -d mu_un=$mu_un -d recomb_un=$recomb_un -d treeSeq=$treeSeq -d mtSelect=$mtSelect \
	-d comp=$comp -d ibd=$ibd -d females_per_male=$females_per_male -d sexRatio=$sexRatio \
	-d outputGen_un=$outputGen_un -d barrier1=$barrier1 -d barrier2=$barrier2 \
	-d scaling=$scaling -d barrier1gen_un=$barrier1gen_un -d barrier2gen_un=$barrier2gen_un \
	-d treeName=\'$treeName-$TIMESTAMP-$i.trees\' -d msName=\'$treeName-$TIMESTAMP-$i.ms\' \
	-d locsName=\'$treeName-$TIMESTAMP-$i.locs\' -d dispMale=$dispMale -d dispFemale=$dispFemale \
	-d dispDevMale=$dispDevMale -d dispDevFemale=$dispDevFemale -d selStrength=$selStrength \
	spatial_ibd_mbd_project_mtnuc_microsat_varsel.slim"

	echo "----------------------------"
	echo "Command is:"
	echo $command
	echo "----------------------------"

	## run the simulation and let it output as needed
	## will output all the runs to .txt and the last run to .temp (inside the slim script being called)
	
	eval $command

done 

