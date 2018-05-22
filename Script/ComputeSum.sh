path="../Log/"
one=1
source=$path$subpath'ph_10_'$var
target=$path$subpath'sumph_10_'$var

########################################################################
############################t0.1########################################
########################################################################

####################################HYBRID
subpath="t=0.1/hybrid/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300 400 1000 2000
do	
	source=$path$subpath'ph_10_'$var
	target=$path$subpath'sumph_10_'$var
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
			echo done
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.16f\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done

####################################EXPLICIT
subpath="t=0.1/explicit/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300
do	
	source=$path$subpath'ph_10_'$var
	target=$path$subpath'sumph_10_'$var
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
			echo done
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.16f\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done



########################################################################
############################t0.001######################################
########################################################################

####################################HYBRID
subpath="t=0.001/hybrid/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300 400 1000 2000
do	
	source=$path$subpath'ph_10_'$var
	target=$path$subpath'sumph_10_'$var
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
			echo done
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.16f\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done

####################################EXPLICIT
subpath="t=0.001/explicit/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300
do	
	source=$path$subpath'ph_10_'$var
	target=$path$subpath'sumph_10_'$var
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
			echo done
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.16f\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done

########################################################################
############################t0.02#######################################
########################################################################

####################################HYBRID
subpath="t=0.02/hybrid/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300 400 1000 2000
do	
	source=$path$subpath'ph_10_'$var
	target=$path$subpath'sumph_10_'$var
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
			echo done
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.16f\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done

####################################EXPLICIT
subpath="t=0.02/explicit/"
for var in 1 2 5 25 50 75 100 125 150 175 200 225 250 275 300
do	
	source=$path$subpath'ph_10_'$var
	target=$path$subpath'sumph_10_'$var
	echo $source
	if [ "$var" = "$one" ]
	then
			cat $source > $target
			echo done
	else
			gawk -v k=${var} -v CONVFMT=%.17g '{s+=$1}NR%k==0{printf "%.16f\n", s;s=0}' "${source}" > $target
			tail -n1 $source >> $target
	fi
done
