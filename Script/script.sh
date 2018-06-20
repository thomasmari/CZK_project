#$1 = t
#$2=eps
sequence=$(seq 1 1 1);
for k in $sequence
	do
		./computeSS_for_different_k.sh "$1" median "1E-$k" constant event
		./computeTime.sh "$1" event median "1E-$k" constant
	done

#~ ./computeTime.sh "$1" hybrid median 151515 standard
#~ ./computeTime.sh "$1" storm median 1513151 standard

#~ #./computeSum.sh path engine epsilon
#~ ./computeSum.sh t="$1"_median_dynamic explicit "$2"
#~ ./computeSum.sh t="$1"_median_standard hybrid "$2"
#$1 t(s) the timeout
#$2 lambda according to t in {regular,median} regular mean lambda = 1/t, and median means t will be the median value of exp(lambda)
#$3 epsilon you want 
#$4 kind_of_epsilon in {dynamic, constant} for dynamic you have eps_computation = eps/k 
#$5 the engine in {event,explicit,hybrid,storm}
