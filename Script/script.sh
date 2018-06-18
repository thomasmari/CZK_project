###################################t=0.1
#~ #./computeSS_for_different_k.sh t lambda eps  eps_type engine
#~ ./computeSS_for_different_k.sh 0.1 median 1E-5  dynamic explicit
#~ ./computeSS_for_different_k.sh 0.1 median 1E-10  dynamic event
#~ ./computeSS_for_different_k.sh 0.1 median 1E-10  constant event
#~ ./computeSS_for_different_k.sh 0.1 median 1E-10  dynamic storm
#~ ./computeSS_for_different_k.sh 0.1 median 1E-10  constant storm
#~ ./computeSS_for_different_k.sh 0.1 median 1E-10  constant hybrid
#~ for i in $(seq 1 1 20);
	#~ do
		#~ ./computeSS_for_different_k.sh 0.1 median 1E-"$i"  dynamic event
		#~ ./computeSS_for_different_k.sh 0.1 median 1E-"$i"  constant event
	#~ done
./computeSS_for_different_k.sh 0.1 median 1E-10  dynamic hybrid



#~ #./computeTime.sh t engine data_type kind_of_epsilon
./computeTime.sh 0.1 explicit median dynamic
./computeTime.sh 0.1 event median dynamic
./computeTime.sh 0.1 hybrid median constant
./computeTime.sh 0.1 hybrid median dynamic
./computeTime.sh 0.1 storm median dynamic
./computeTime.sh 0.1 storm median constant
./computeTime.sh 0.1 event median constant
./computeTime.sh 0.1 event median dynamic
./computeTime.sh 0.1 storm median dynamic
./computeTime.sh 0.1 storm median constant

#~ #./computeSum.sh path engine epsilon
./computeSum.sh t=0.1_median_dynamic explicit 1E-10
./computeSum.sh t=0.1_median_constant hybrid 1E-10
./computeSum.sh t=0.1_median_dynamic hybrid 1E-10


