#compute steady state probabilities for various termination epsilon values.
#This script must remain in CZK_project/Script !!!

#There are two parameters. 
#First parameter is t, the timeout inbetween arrivals.
#Second parameter is k, the number of intermediate points simulating the deterministic distribution.
#Lambda is choosen as lambda = ln(2)/t

PRISM_PATH_FROM_SCRIPT="../../../../prismGSMP/prism-gsmp/prism/bin"
MODEL_PATH_FROM_PRISM="../../../../CZK_project/Model"
OUTPUT_PATH_FROM_PRISM="../../../../CZK_project/Output"

#lambda=$(bc <<< "scale=10;1/$1")
lambda=$(bc <<< "scale=10;0.693147181/$1")


reNum='^[-+]?[0-9]+\.?[0-9]*$'
if ! [[ $1 =~ $reNum ]]; then
  echo "Please specify number \"timeout\" as the first parameter!"
  exit 1
fi

if ! [[ $2 =~ $reNum ]]; then
  echo "Please specify number \"k\" as the second parameter!"
  exit 2
fi

cd '../Output'

mkdir "t=$1_epsilon"
cd "t=$1_epsilon"
mkdir "explicit"
cd "explicit"

cd $PRISM_PATH_FROM_SCRIPT
#compute explicit phase type
for i in 1E-1 1E-2 1E-3 1E-4 1E-5 1E-6 1E-7 1E-8 1E-9 1E-10 1E-11 1E-12 1E-13
do
	echo explicit $2 $i
  ./prism -explicit -epsilon $i -maxiters 10000000 -power -absolute -const k=$2,timeout=$1,lambda=$lambda "$MODEL_PATH_FROM_PRISM/queue_withptf_gsmp.sm" -ss -exportss "$OUTPUT_PATH_FROM_PRISM/t=$1_epsilon/explicit/ph_10_$2_$i" > "$OUTPUT_PATH_FROM_PRISM/t=$1_epsilon/explicit/ph_10_$2_$i.log"
done

#compute explicit event
for i in 1E-1 1E-2 1E-3 1E-4 1E-5 1E-6 1E-7 1E-8 1E-9 1E-10 1E-11 1E-12 1E-13
do
	echo event $2 $i
	./prism -explicit -epsilon $i -maxiters 10000000 -power -absolute -const k=$2,timeout=$1,lambda=$lambda  "$MODEL_PATH_FROM_PRISM/timeoutqueue.sm" -ss -exportss "$OUTPUT_PATH_FROM_PRISM/t=$1_epsilon/explicit/ev_10_k_"${i} > "$OUTPUT_PATH_FROM_PRISM/t=$1_epsilon/explicit/ev_10_k_"${i}".log"
done

cd -

#write a readme file for explicit computations
touch readme.txt
echo "t=$1" >> readme.txt
echo "lambda=1/t" >> readme.txt
echo "n=10" >> readme.txt
echo "naming: ev/ph_n_k_terminationEpsilon" >> readme.txt
echo "steady state distributions using the GSMP (ctmc with phase type) explicit engine
for different termination epsilons for phase type, and termination epsilon 1.0E-9 for event." >> readme.txt

cd "../"
mkdir "hybrid"
cd "hybrid"

cd $PRISM_PATH_FROM_SCRIPT
#compute hybrid phase type
for i in 1E-1 1E-2 1E-3 1E-4 1E-5 1E-6 1E-7 1E-8 1E-9 1E-10 1E-11 1E-12 1E-13
do
	echo hybrid $2 $i
  ./prism -hybrid -epsilon ${i} -maxiters 10000000 -power -absolute -const k=$2,timeout=$1,lambda=$lambda "$MODEL_PATH_FROM_PRISM/queue_withptf_ctmc.sm" -ss -exportss "$OUTPUT_PATH_FROM_PRISM/t=$1_epsilon/hybrid/ph_10_$2_"${i} > "$OUTPUT_PATH_FROM_PRISM/t=$1_epsilon/hybrid/ph_10_$2_"${i}".log"
done
cd -

#write a readme file for hybrid computations
touch readme.txt
echo "t=$1" >> readme.txt
echo "lambda=1/t" >> readme.txt
echo "n=10" >> readme.txt
echo "naming: ph_n_k_terminationEpsilon" >> readme.txt
echo "steady state distributions using the CTMC with phase type on hybrid engine with Power method
absolute termination criteria for different termination epsilons for phase type." >> readme.txt


