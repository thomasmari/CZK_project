#$1 = t
#$2=eps

if [ "$1" == "help" ]; then
	echo '2 argument are expected :'
	echo '$1 is the the timeout in second, the one we choose to run tests was 0.1'
	echo '$2 is the the precision epsilon in [1-9]+{E-}[1-9]+ format, in prism it is the termination epsilon for power method, in storm it set the --epsilon option (1E-6 is the default value for both PRISM and Storm)'
	echo 'Result :'
	echo 'It will compute logs and outputs of computations for both dynamic and constant epsilon for Storm, PRISM and ACTMC PRISM into the Output folder'
	exit 1
	fi

#~COMPUTATION
#./computeSS_for_different_k.sh t lambda eps  eps_type engine

./computeSS_for_different_k.sh "$1" median "$2"  event
./computeSS_for_different_k.sh "$1" median "$2"  event
./computeSS_for_different_k.sh "$1" median "$2"  storm dynanic
./computeSS_for_different_k.sh "$1" median "$2"  storm constant
./computeSS_for_different_k.sh "$1" median "$2"  hybrid dynamic
./computeSS_for_different_k.sh "$1" median "$2"  hybrid constant


#~ POSTCOMPUTATION
#~ #./computeTime.sh t engine data_type kind_of_epsilon

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


