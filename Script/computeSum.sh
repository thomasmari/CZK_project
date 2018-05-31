#!/bin/bash
#####README
# $1 = path from "../Output/"  example t=?_regular_dynamic 
# $2 = engine in {explicit,hybrid}
# $3 = epsilon
# The logs (for t) must be already computed 
# computeTime must be already computed
# In the result the kline is the time of computation for the ph_n_k_eps
# naming : sumph_n_k_epsilon, the folder give the engine and the timeout
# Are fixed constant : epsilon=1E-5
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


	
