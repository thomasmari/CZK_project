#####README
# There is only one parameters, that is t. The logs (for t) must be already computed 
# Return a file of computation time for hybrid and explicit engine in both of their folders
path="../Log/t=$1"


####################################HYBRID
subpath="t=$1/hybrid/"
target=$path$subpath'sumph_10_'$var
touch tempfile
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300 400 1000 2000
do	
	source=$path$subpath'ph_10_'$var
	grep "Time for steady-state probability computation" source >> tempfile
done
grep -Eo '[0-9]+.[0-9]+' tempfile > target
rm -f tempfile
####################################EXPLICIT
subpath="t=0.1/explicit/"
target=$path$subpath'sumph_10_'$var
touch tempfile
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300 400 1000 2000
do	
	source=$path$subpath'ph_10_'$var
	grep "Time for steady-state probability computation" source >> tempfile
done
grep -Eo '[0-9]+.[0-9]+' tempfile > target
rm -f tempfile

