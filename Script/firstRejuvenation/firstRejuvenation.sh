#Here you can set the sequence of k computed
sequence=$(seq 1 1 9; seq 10 10 90; seq 100 100 900; seq 1000 1000 4000; seq 5000 5000 5000);
epsilon = 1E-6

for eps in 1E-6 1E-10 1E-15 1E-20
	do
	./computeSS_firstRejuvenation.sh $eps event
	done


for eps in 1E-6 1E-10
	do
		for k in $sequence
			do
			./computeSS_firstRejuvenation.sh $eps hybrid constant "$k" 
			./computeSS_firstRejuvenation.sh $eps hybrid dynamic "$k" 
			done
	done
