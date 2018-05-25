#####README
# There is only one parameters, that is t. The logs (for t) must be already computed 
# Return a file of the sum of probabilities per state of the queue
# In the result the kline is the time of computation for the ph_n_k_eps
# naming : sumph_n_k_epsilon, the folder give the engine and the timeout
# Are fixed constant : epsilon=1E-5
path="../Output/"
one=1
eps="1E-5"

########################################################################
############################t###########################################
########################################################################

####################################HYBRID
subpath="t=$1_median/hybrid/"
for var in $(seq 5 5 95; seq 100 100 5000);
do	
	source=$path$subpath'ph_10_'$var'_'$eps
	target=$path$subpath'sumph_10_'$var'_'$eps
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.20lf\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done

####################################EXPLICIT
subpath="t=$1_median/explicit/"
for var in $(seq 5 5 95; seq 100 100 5000);
do	
	source=$path$subpath'ph_10_'$var'_'$eps
	target=$path$subpath'sumph_10_'$var'_'$eps
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.20lf\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done
