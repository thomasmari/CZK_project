#####README
# There is only one parameters, that is t. The logs (for t) must be already computed 
# Return a file of the sum of probabilities per state of the queue
# In the result the kline is the time of computation for the ph_n_k_eps
# naming : sumph_n_k_epsilon, the folder give the engine and the timeout
# Are fixed constant : epsilon=1E-5
path="../Output/"
one=1
esp="1E-5"

########################################################################
############################t###########################################
########################################################################

####################################HYBRID
subpath="t=$1/hybrid/"
for var in 1 2 5 10 25 50 75 100 125 150 175 200 225 250 275 300 500 1000 2000
do	
	source=$path$subpath'ph_10_'$var'_'$esp
	target=$path$subpath'sumph_10_'$var'_'$esp
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.16f\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done

####################################EXPLICIT
subpath="t=$1/explicit/"
for var in 1 2 5 10 25 50 75 100 125 150 175 200 225 250 275 300 500 1000 20000
do	
	source=$path$subpath'ph_10_'$var'_'$esp
	target=$path$subpath'sumph_10_'$var'_'$esp
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.16f\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done
