#$1 = t
#$2=eps


#~ ###################################t=0.1
#./computeSS_for_different_k.sh t lambda eps  eps_type engine
#~ ./computeSS_for_different_k.sh "$1" median "$2"  dynamic explicit
./computeSS_for_different_k.sh "$1" median "$2"  dynamic event
./computeSS_for_different_k.sh "$1" median "$2"  constant event
./computeSS_for_different_k.sh "$1" median "$2"  dynamic storm
./computeSS_for_different_k.sh "$1" median "$2"  constant storm
./computeSS_for_different_k.sh "$1" median "$2"  dynamic hybrid
./computeSS_for_different_k.sh "$1" median "$2"  constant hybrid


#~ #./computeTime.sh t engine data_type kind_of_epsilon
#~ ./computeTime.sh "$1" explicit median dynamic
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


