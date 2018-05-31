#compute steady state probabilities for various k values.
#This script must remain in CZK_project/Script !!!
#There is only one parameter - floating point number specifying the timeout.
#Lambda is derived as (ln 2 / timeout).

PRISM_PATH_FROM_SCRIPT="../../../../prismGSMP/prism-gsmp/prism/bin"
MODEL_PATH_FROM_PRISM="../../../../CZK_project/Model"
OUTPUT_PATH_FROM_PRISM="../../../../CZK_project/Output"

lambda=$(bc <<< "scale=10;0.693147181/$1")
eps="1E-12"
eps_precise="1E-10"

reNum='^[-+]?[0-9]+\.?[0-9]*$'
if ! [[ $1 =~ $reNum ]]; then
  echo "Please specify number \"timeout\" as the first parameter!"
  exit 1
fi

cd '../Output'

mkdir "t=$1_median_test"
cd "t=$1_median_test"
mkdir "hybrid"
cd "hybrid"

cd $PRISM_PATH_FROM_SCRIPT
#compute hybrid phase type
for k in $(seq 1500 1 1500);
do
	echo hybrid $k $eps
  ./prism -hybrid -epsilon ${eps} -maxiters 100000000 -power -absolute -const k=$k,timeout=$1,lambda=$lambda "$MODEL_PATH_FROM_PRISM/queue_withptf_ctmc.sm" -ss -exportss "$OUTPUT_PATH_FROM_PRISM/t=$1_median_test/hybrid/ph_10_${k}_${eps}" > "$OUTPUT_PATH_FROM_PRISM/t=$1_median_test/hybrid/ph_10_${k}_${eps}.log"
done
