#./computeSS_for_different_k.sh t lambda eps  eps_type engine
./computeSS_for_different_k.sh 0.1 median 1E-5  dynamic explicit
./computeSS_for_different_k.sh 0.1 median 1E-5  dynamic event
./computeSS_for_different_k.sh 0.1 median 1E-5  dynamic hybrid


#./computeTime.sh t engine data_type kind_of_epsilon
./computeTime.sh 0.1 explicit median dynamic
./computeTime.sh 0.1 event median dynamic
./computeTime.sh 0.1 hybrid median dynamic

#./computeSum.sh path engine epsilon
./computeSum.sh t=0.1_median_dynamic explicit 1E-5
./computeSum.sh t=0.1_median_dynamic event 1E-5
./computeSum.sh t=0.1_median_dynamic hybrid 1E-5
