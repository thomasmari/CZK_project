#####README
# There is only one parameters, that is t. The logs (for t) must be already computed 
# Return a file of computation time for hybrid and explicit engine in both of their folders
# In the result the kline is the time of computation for the ph_n_k_eps
# naming : phtime_n_epsilon, the folder give the engine and the timeout
# Are fixed constant : epsilon=1E-5
path="../Output/t=$1/"
eps="1E-5"


reNum='^[-+]?[0-9]+\.?[0-9]*$'
if ! [[ $1 =~ $reNum ]]; then
  echo "Please specify number \"timeout\" as the first parameter!"
  exit 1
fi


####################################HYBRID
subpath="hybrid/"
targettime=$path$subpath'phtime_10_'${eps}
targetk=$path$subpath'k_array'
touch tempfiletime
touch tempfilek1
touch tempfilek2
for var in 1 2 5 10 25 50 75 100 125 150 175 200 225 250 275 300 500 1000 2000 3000 4000 5000
do	
	source=$path$subpath'ph_10_'$var'_'${eps}'.log'
	grep "Time for steady-state probability computation" $source >> tempfiletime
	grep "Command line: prism" $source >> tempfilek1
done
grep -Eo '[0-9]+.[0-9]+' tempfiletime > $targettime
grep -Eo 'k=[0-9]+' tempfilek1 > tempfilek2
grep -Eo '[0-9]+' tempfilek2 > $targetk

rm -f tempfilek1
rm -f tempfilek2
rm -f tempfiletime
####################################EXPLICIT
subpath="explicit/"
targettime=$path$subpath'phtime_10_'${eps}
targetk=$path$subpath'k_array'
touch tempfiletime
touch tempfilek1
touch tempfilek2
for var in 1 2 5 10 25 50 75 100 125 150 175 200 225 250 275 300 500 1000 2000 3000 4000 5000
do	
	source=$path$subpath'ph_10_'$var'_'${eps}'.log'
	grep "Time for steady-state probability computation" $source >> tempfiletime
	grep "Command line: prism" $source >> tempfilek1
done
grep -Eo '[0-9]+.[0-9]+' tempfiletime > $targettime
grep -Eo 'k=[0-9]+' tempfilek1 > tempfilek2
grep -Eo '[0-9]+' tempfilek2 > $targetk

rm -f tempfilek1
rm -f tempfilek2
rm -f tempfiletime

####################################EVENT
targettime=$path$subpath'evtime_10_'${eps}
touch tempfiletime
source=$path$subpath'ev_10_k_'${eps}'.log'
grep "Time for steady-state probability computation" $source >> tempfiletime
grep -Eo '[0-9]+.[0-9]+' tempfiletime > $targettime
rm -f tempfiletime
