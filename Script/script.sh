#./computeSS_for_different_k.sh t lambda eps  eps_type engine
./computeSS_for_different_k.sh 0.1 median 1E-5  dynamic explicit
./computeSS_for_different_k.sh 0.1 median 1E-5  dynamic event
./computeSS_for_different_k.sh 0.1 median 1E-5  dynamic hybrid


#./comuteTime t engine data_type kind_of_epsilon
./comuteTime 0.1 explicit median dynamic
./comuteTime 0.1 event median dynamic
./comuteTime 0.1 hybrid median dynamic

#./computeSum path engine epsilon
./computeSum t=0.1_median_dynamic explicit 1E-5
./computeSum t=0.1_median_dynamic event 1E-5
./computeSum t=0.1_median_dynamic hybrid 1E-5
