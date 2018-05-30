#/bin/bash
#####README
# There two parameters, 
# $1 =  t
# $2 = k
#The logs (for t) must be already computed 
# Return a file of the sum of probabilities per state of the queue
# In the result the kline is the time of computation for the ph_n_k_eps
# naming : sumph_n_k_epsilon, the folder give the engine and the timeout

path="../Output/"

########################################################################
############################t###########################################
########################################################################

####################################HYBRID
subpath="t=$1_epsilon/hybrid/"
for var in $(seq 1 1 9);
do	
	source=$path$subpath'ph_10_'$2'_1E-'$var
	target=$path$subpath'sumph_10_'$2'_1E-'$var
	if (( $2 == 1));
	then
			cat $source > $target
	else
			gawk -v k=$2 -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.20lf\n", s;s=0}' "${source}" > $target
	fi
done

####################################EXPLICIT
subpath="t=$1_epsilon/explicit/"
for var in $(seq 1 1 9);
do	
	source=$path$subpath'ph_10_'$2'_1E-'$var
	target=$path$subpath'sumph_10_'$2'_1E-'$var
	if (( $2 == 1));
	then
			cat $source > $target
	else
			gawk -v k=$2 -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.20lf\n", s;s=0}' "${source}" > $target
	fi
done
