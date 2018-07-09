#####README
# The logs (for t) must be already computed 
# $1 = engine/data in {event,hybrid,explicit,storm}
# $2 = epsilon (doesn't count if standard, put "1E-0" or "standard" or anything)
# $3 kind_of_epsilon in {dynamic, constant, standard} for dynamic you have eps_computation = eps/k 
# Return a file of computation time for hybrid and explicit engine in both of their folders
# In the result the kline is the time of computation for the ph_k_eps
# naming : phtime_epsilon, the folder give the engine and the timeout

if [ "$1" == "help" ]; then
	echo '5 argument are expected :'
	echo '$1 the engine in {event,explicit,hybrid,storm} that will do the computation'
	echo '   event is the ACTMC model checker'
	echo '   explicit is the ACTMC model checker for only CTMC model'
	echo '   hybrid is the PRISM model checker with hybrid engine'
	echo '   storm is the Storm model checker with sparse engine'
	echo '$2 is the the precision epsilon in [1-9]+{E-}[1-9]+ format, in prism it is the termination epsilon for power method, in storm it set the --epsilon option (1E-6 is the default value for both PRISM and Storm)'
	echo '$3 kind_of_epsilon in {dynamic, constant} for dynamic you have eps_computation = eps/k '
	echo '   constant : the precision epsilon will remain the same for every computations'
	echo '   dynamic : the precision epsilon will depend on k eps_computation = eps/k'
	

	echo 'Result :'
	echo 'It will extract from the logs the time of computation, the result for Storm, the list of ph fiting parameter k used'
	exit 1
	fi

engine="$1"

#Path Setting
path="../../Output/firstRejuvenation_$2_$3/"

#engine setting
if [ "$1" == "hybrid" ]; then
	subpath="hybrid/"
elif [ "$1" == "storm" ]; then
	subpath="storm/"
else
	subpath="explicit/"
fi

#data setting
if [[ $1 =~ 'event' ]]; then
	data="ev"
else
	data="ph"
fi



target_time=$path$subpath$data'_time_10'
rm -f $target_time #in case of recomputation
target_eps=$path$subpath$data'_eps_array'
rm -f $target_eps
if ! [[ $1 =~ 'event' ]]; then
	target_k=$path$subpath$data'_k_array'
	rm -f $target_k
fi


touch temp
touch temp_command
touch temp_eps
touch temp_time
touch temp_k


echo extracting log ...
echo $path
echo $subpath
for file in $(ls -t -r  $path$subpath$data*.log); #the order of modification matter = reverse order of last modification
do	
	echo $file
	cat $file >> temp #concat logs in temp
done
echo done

echo extracting command
grep "Command line: prism"  temp > temp_command
grep "Command line arguments: --prism"  temp >> temp_command #concat command in temp_command

echo done

if [ "$1" != "event" ]; then
	echo k_array
	grep -Eo 'k=[0-9]+' temp_command > temp_k
	grep -Eo '[0-9]+' temp_k > $target_k
	sort -g $target_k >temp_k #sort the value in k_array
	cat temp_k >$target_k
fi
echo done


echo epsilon and time ...

if [[ $1 =~ 'event' ]]; then
	file=$path$subpath$data'_10_k_'$2'.log'
	echo $file
	#epsilon
	grep 'epsilon' $file > temp_eps0
	grep -Eo 'epsilon ([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps0 > temp_eps
	grep -Eo '([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps >> $target_eps
	#time
	grep "Time for steady-state probability computation:" $file > temp_time
	grep -Eo '[0-9]+.[0-9]+' temp_time >> $target_time
else
	cat $target_k| while read line
	do
	for file in $(ls $path$subpath$data'_'$line'_'*.log); #the order of modification matter = reverse order of last modification but there is in fqct only one file corresponding
		do	
			echo $file
			#epsilon
			if [[ $1 =~ 'storm' ]]; then
				grep 'k=' $file > temp_eps0
				grep -Eo 'precision ([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps0 > temp_eps
				grep -Eo '([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps >> $target_eps
			else
				grep 'k=' $file > temp_eps0
				grep -Eo 'epsilon ([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps0 > temp_eps
				grep -Eo '([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps >> $target_eps
			fi
			#time
			if [[ $1 =~ 'storm' ]]; then
				grep "Time for model checking:" $file > temp_time
				grep -Eo '[0-9]+.[0-9]+' temp_time > temp_time2
				gawk -v k=11 -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.20lf\n", s;s=0}' temp_time2 > temp_time
				time=$(cat temp_time)
				echo "scale=2; $time / 11" | bc >> $target_time
			else
				grep "Time for steady-state probability computation:" $file > temp_time
				grep -Eo '[0-9]+.[0-9]+' temp_time >> $target_time
			fi
			#result extract
			if [[ $1 =~ 'storm' ]]; then
				target=${file::-4}
				grep "Result (initial states)" $file > temp_file
				grep -Eo '([0-9]+[e E]-[0-9]+|[0-9]+[.]?[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_file > $target
			fi
		done
	done
fi


echo erasing temps
rm -f temp_command
rm -f temp
rm -f temp_time
rm -f temp_time2
rm -f temp_eps
rm -f temp_eps0
rm -f temp_k
rm -f temp_file
echo done
