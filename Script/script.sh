#$1 = t
#$2=eps


./computeTime.sh "$1" hybrid median standard
./computeTime.sh "$1" storm median standard

#~ #./computeSum.sh path engine epsilon
#~ ./computeSum.sh t="$1"_median_dynamic explicit "$2"
./computeSum.sh t="$1"_median_standard hybrid "$2"
