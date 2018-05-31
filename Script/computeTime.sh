#####README
# There is only one parameters, that is t. The logs (for t) must be already computed 
# $1 = t(int) the timeout
# $2 = engine/data in {event,hybrid,explicit}
# $3 = data_type in {regular,epsilon,median}
# $4 kind_of_epsilon in {dynamic, constant} for dynamic you have eps_computation = eps/k 
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
if [ "$3" == "regular" ]; then
	path="../Output/t=$1_regular_$4/"
elif [ "$3" == "epsilon" ]; then
	path="../Output/t=$1_epsilon_$4/"
else
	path="../Output/t=$1_median_$4/"
fi

#engine setting
if [ "$2" == "hybrid" ]; then
	subpath="hybrid/"
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
target_eps=$path$subpath$data'_eps_array'
target_k=$path$subpath$data'_k_array'

touch temp
touch temp_command
touch temp_eps
touch temp_time
touch temp_k

echo extracting log ...
for file in $(ls -t -r  $path$subpath$data*.log); #the order of modification matter = reverse order of last modification
do	
	echo $file
	cat $file >> temp #concat logs in temp
done
echo done

echo time ...
grep "Time for steady-state probability computation" temp > temp_time
grep -Eo '[0-9]+.[0-9]+' temp_time > $target_time
echo done

echo extracting command
grep "Command line: prism"  temp > temp_command
echo done


echo eps ...
grep -Eo '-epsilon ([0-9]+e-[0-9]+|[0-9]+.[0-9]+(e-[0-9]+)?)' temp_command > temp_eps
grep -Eo '([0-9]+e-[0-9]+|[0-9]+.[0-9]+(e-[0-9]+)?)' temp_eps > $target_eps
echo done

if [ "$2" != "event" ]; then
	grep -Eo 'k=[0-9]+' temp_command > temp_k
	grep -Eo '[0-9]+' temp_k > $target_k
fi



echo erasing temps
#rm -f temp_command
rm -f temp
rm -f temp_time
rm -f temp_eps
rm -f temp_k
echo done

