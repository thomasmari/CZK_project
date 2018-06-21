#####README
# The logs (for t) must be already computed 
# $1 = t(int) the timeout
# $2 = engine/data in {event,hybrid,explicit,storm}
# $3 = data_type in {regular,epsilon,median}
# $4 = epsilon (doesn't count if standard, put "1E-0" or "standard" or anything)
# $5 kind_of_epsilon in {dynamic, constant, standard} for dynamic you have eps_computation = eps/k 
# Return a file of computation time for hybrid and explicit engine in both of their folders
# In the result the kline is the time of computation for the ph_n_k_eps
# naming : phtime_n_epsilon, the folder give the engine and the timeout
reNum='^[-+]?[0-9]+\.?[0-9]*$'
if ! [[ $1 =~ $reNum ]] ; then
  echo "Please specify number \"timeout\" as the first parameter!"
  exit 1
fi

engine="$2"

#Path Setting
if [ "$5" == "standard" ]; then
	if [ "$3" == "regular" ]; then
		path="../Output/t=$1_regular_standard/"
	elif [ "$3" == "epsilon" ]; then
		path="../Output/t=$1_epsilon_standard/"
	else
		path="../Output/t=$1_median_standard/"
	fi
else
	if [ "$3" == "regular" ]; then
		path="../Output/t=$1_regular_$4_$5/"
	elif [ "$3" == "epsilon" ]; then
		path="../Output/t=$1_epsilon_$4_$5/"
	else
		path="../Output/t=$1_median_$4_$5/"
	fi
fi

#engine setting
if [ "$2" == "hybrid" ]; then
	subpath="hybrid/"
elif [ "$2" == "storm" ]; then
	subpath="storm/"
else
	subpath="explicit/"
fi

#data setting
if [[ $2 =~ 'event' ]]; then
	data="ev"
else
	data="ph"
fi



target_time=$path$subpath$data'_time_10'
rm -f $target_time #in case of recomputation
target_eps=$path$subpath$data'_eps_array'
rm -f $target_eps
if ! [[ $2 =~ 'event' ]]; then
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

if [ "$2" != "event" ]; then
	echo k_array
	grep -Eo 'k=[0-9]+' temp_command > temp_k
	grep -Eo '[0-9]+' temp_k > $target_k
	sort -g $target_k >temp_k #sort the value in k_array
	cat temp_k >$target_k
fi
echo done


echo epsilon and time ...

if [[ $2 =~ 'event' ]]; then
	file=$path$subpath$data'_10_k_'$4'.log'
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
	for file in $(ls $path$subpath$data'_10_'$line'_'*.log); #the order of modification matter = reverse order of last modification but there is in fqct only one file corresponding
		do	
			echo $file
			#epsilon
			if [[ $2 =~ 'storm' ]]; then
				grep 'k=' $file > temp_eps0
				grep -Eo 'precision ([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps0 > temp_eps
				grep -Eo '([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps >> $target_eps
			else
				grep 'k=' $file > temp_eps0
				grep -Eo 'epsilon ([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps0 > temp_eps
				grep -Eo '([0-9]+[e E]-[0-9]+|[0-9]+.[0-9]+([e E]-[0-9]+)?)' temp_eps >> $target_eps
			fi
			#time
			if [[ $2 =~ 'storm' ]]; then
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
			if [[ $2 =~ 'storm' ]]; then
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
