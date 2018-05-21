PATH='../Log/'






SUBPATH="TEST/hybrid/"
folder=$PATH$SUBPATH
Array=("1" "2" "5" "25" "50" "75" "10" "125" "150" "175" "200" "225" "250" "275" "300" "400" "1000" "2000")
for var in "${Array[@]}" :
do
	file='ph_10_'${var}
	gawk -v k="${var}" '{s+=$1}NR%"k"==0{print s;s=0}' "${file}" #> "sum""${file}"
done


