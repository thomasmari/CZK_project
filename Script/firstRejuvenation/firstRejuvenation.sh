#~ #Here you can set the sequence of k computed
#~ sequence=$(seq 1 1 9; seq 10 10 90; seq 100 100 900; seq 1000 1000 4000; seq 5000 5000 5000);

#~ for eps in 1E-6 1E-10 1E-15 1E-20
	#~ do
	#~ ./computeSS_firstRejuvenation.sh $eps event
	#~ done


#~ for eps in 1E-6 1E-10
	#~ do
		#~ for k in $sequence
			#~ do
			#~ ./computeSS_firstRejuvenation.sh $eps hybrid constant "$k" 
			#~ ./computeSS_firstRejuvenation.sh $eps hybrid dynamic "$k" 
			#~ done
	#~ done

#####COMPUTETIME
	./computeTime.sh event 1E-6 constant
	./computeTime.sh event 1E-10 constant
	./computeTime.sh event 1E-15 constant
	./computeTime.sh event 1E-20 constant
	
	./computeTime.sh hybrid 1E-6 constant
	./computeTime.sh hybrid 1E-10 constant
	
	./computeTime.sh hybrid 1E-6 dynamic
	./computeTime.sh hybrid 1E-10 dynamic

####COMUTESUM
	./computeSum.sh firstRejuvenation_1E-6_dynamic hybrid 1E-6
	./computeSum.sh firstRejuvenation_1E-6_constant hybrid 1E-6
	./computeSum.sh firstRejuvenation_1E-10_dynamic hybrid 1E-10
	./computeSum.sh firstRejuvenation_1E-10_constant hybrid 1E-10
