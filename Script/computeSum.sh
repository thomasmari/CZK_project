#!/bin/bash
#####README
# $1 = path from "../Output/"  example t=?_regular_dynamic 
# $2 = engine in {explicit,hybrid}
# $3 = epsilon or standart
# The logs (for t) must be already computed 
# computeTime must be already computed
# In the result the kline is the time of computation for the ph_n_k_eps
# naming : sumph_n_k_epsilon, the folder give the engine and the timeout
# Are fixed constant : epsilon=1E-5

if [ "$1" == "help" ]; then
	echo '3 argument are expected :'
	echo '$1 is the name of the folder which contains the results from "../Output/" example : "t=0.1_median_1E-10_dynamic"'
	echo '$2 the engine in {explicit,hybrid} that will do the computation'
	echo '   explicit is the ACTMC model checker for only CTMC model'
	echo '   hybrid is the PRISM model checker with hybrid engine'
	echo '$3 is the the precision epsilon in [1-9]+{E-}[1-9]+ format, in prism it is the termination epsilon for power method, in storm it set the --epsilon option (1E-6 is the default value for both PRISM and Storm)'
	echo 'Result :'
	echo 'It will compute the compute the steady probability for the set of states with same qSize, in fact we add the probabilities of each states with same qSize, computeTime must be lauched before this script'
	exit 1
	fi

path="../Output/"
subpath=$1
engine=$2
one=1
eps="$3"

for line in $(cat "${path}${subpath}/${engine}/ph_k_array"); 
do 
	source=${path}${subpath}'/'${engine}'/ph_10_'${line}'_'$eps
	target=${path}${subpath}'/'${engine}'/sumph_10_'${line}'_'$eps
	echo $source
	if [ "$line" = "$one" ]
	then
			cat $source > $target
	else
			gawk -v k=${line} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.20lf\n", s;s=0}' "${source}" > $target
	fi
done 


	
