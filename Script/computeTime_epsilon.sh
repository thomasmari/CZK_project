#####README
# There is only one parameters, that is t. The logs (for t) must be already computed 
# $1 = t(int) the timeout
# $2 = engine/data in {"event","hybrid","explicit"}
# Return a file of computation time for hybrid and explicit engine in both of their folders
# In the result the kline is the time of computation for the ph_n_k_eps
# naming : phtime_n_epsilon, the folder give the engine and the timeout
reNum='^[-+]?[0-9]+\.?[0-9]*$'
if ! [[ $1 =~ $reNum ]]; then
  echo "Please specify number \"timeout\" as the first parameter!"
  exit 1
fi
if ! [[ $1 =~ $reNum ]]; then
  echo "Please specify number \"timeout\" as the first parameter!"
  exit 1
fi

path="../Output/t=$1_epsilon/"

if [[ $2 =~ 'hybrid' ]]; then
	subpath="hybrid/"
else
	subpath="explicit/"
fi

if [[ $2 =~ 'event' ]]; then
	data="ev"
else
	data="ph"
fi



target_time=$path$subpath$data'time_10'
target_eps=$path$subpath'eps_array'

touch temp
touch temp_command
touch temp_eps
touch temp_time

echo extracting log ...
for file in $(ls $path$subpath'ph'*.log);
do	
	echo $file
	cat $file >> temp
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
grep -Eo '-epsilon 1E-[0-9]+' temp_command > temp_eps
grep -Eo '1E-[0-9]+' temp_eps > $target_eps
echo done

echo erasing temps
rm -f temp_command
rm -f temp
rm -f temp_time
rm -f temp_eps
echo done

