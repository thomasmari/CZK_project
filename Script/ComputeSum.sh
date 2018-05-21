path="../Log/"


########################################################################
############################t0.1########################################
########################################################################

####################################HYBRID
subpath="t=0.1/hybrid/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300 400 1000 2000
do
	file=$path$subpath'ph_10_'${var}
	echo $file
	gawk -v k=${var} '{s+=$1}NR%k==0{print s;s=0}' "${file}" > $path$subpath'sumph_10_'$var 
done

####################################EXPLICIT
subpath="t=0.1/explicit/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300
do
	file=$path$subpath'ph_10_'${var}
	echo $file
	gawk -v k=${var} '{s+=$1}NR%k==0{print s;s=0}' "${file}" > $path$subpath'sumph_10_'$var 
done



########################################################################
############################t0.001######################################
########################################################################

####################################HYBRID
subpath="t=0.001/hybrid/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300 400 1000 2000
do
	file=$path$subpath'ph_10_'${var}
	echo $file
	gawk -v k=${var} '{s+=$1}NR%k==0{print s;s=0}' "${file}" > $path$subpath'sumph_10_'$var 
done

####################################EXPLICIT
subpath="t=0.001/explicit/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300
do
	file=$path$subpath'ph_10_'${var}
	echo $file
	gawk -v k=${var} '{s+=$1}NR%k==0{print s;s=0}' "${file}" > $path$subpath'sumph_10_'$var 
done

########################################################################
############################t0.02#######################################
########################################################################

####################################HYBRID
subpath="t=0.02/hybrid/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300 400 1000 2000
do
	file=$path$subpath'ph_10_'${var}
	echo $file
	gawk -v k=${var} '{s+=$1}NR%k==0{print s;s=0}' "${file}" > $path$subpath'sumph_10_'$var 
done

####################################EXPLICIT
subpath="t=0.02/explicit/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300
do
	file=$path$subpath'ph_10_'${var}
	echo $file
	gawk -v k=${var} '{s+=$1}NR%k==0{print s;s=0}' "${file}" > $path$subpath'sumph_10_'$var 
done

