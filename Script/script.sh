#$1 = t
#$2=eps

./computeTime.sh "$1" hybrid median constant
./computeTime.sh "$1" hybrid median dynamic

./computeTime.sh "$1" event median dynamic
./computeTime.sh "$1" event median constant

./computeTime.sh "$1" storm median dynamic
./computeTime.sh "$1" storm median constant
./computeTime.sh "$1" storm median dynamic
./computeTime.sh "$1" storm median constant

#~ #./computeSum.sh path engine epsilon
#~ ./computeSum.sh t="$1"_median_dynamic explicit "$2"
./computeSum.sh t="$1"_median_"$2"_constant hybrid "$2"
./computeSum.sh t="$1"_median_"$2"_dynamic hybrid "$2"

./computeSum.sh t="$1"_median_"$2"_constant explicit "$2"
./computeSum.sh t="$1"_median_"$2"_dynamic explicit "$2"
