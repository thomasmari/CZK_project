#compute steady state probabilities for various k values.
#This script must remain in CZK_project/Script !!!
#There is only one parameter - floating point number specifying the timeout.
#Lambda is derived as (ln 2 / timeout).

PRISM_PATH_FROM_SCRIPT="../../../../prismGSMP/prism-gsmp/prism/bin"
MODEL_PATH_FROM_PRISM="../../../../CZK_project/Model"
LOG_PATH_FROM_PRISM="../../../../CZK_project/Log"

lambda=$(bc <<< "scale=10;0.693147181/$1")

reNum='^[-+]?[0-9]+\.?[0-9]*$'
if ! [[ $1 =~ $reNum ]]; then
  echo "Please specify number \"timeout\" as the first parameter!"
  exit 1
fi

cd '../Log'

mkdir "t=$1_median"
cd "t=$1_median"
mkdir "explicit"
cd "explicit"

cd $PRISM_PATH_FROM_SCRIPT
#compute explicit phase type
for k in 1 2 5 10 25 50 75 100 125 150 175 200 225 250 275 300
do
  ./prism -explicit -epsilon 1e-5 -maxiters 100000000 -power -absolute -const k=$k,timeout=$1,lambda=$lambda "$MODEL_PATH_FROM_PRISM/queue_withptf_gsmp.sm" -ss -exportss "$LOG_PATH_FROM_PRISM/t=$1_median/explicit/ph_10_${k}_1E-5" > "$LOG_PATH_FROM_PRISM/t=$1_median/explicit/ph_10_${k}_1E-5.log"
done

#compute explicit event
./prism -explicit -epsilon 1e-8 -maxiters 100000000 -power -absolute -const timeout=$1,lambda=$lambda "$MODEL_PATH_FROM_PRISM/timeoutqueue.sm" -ss -exportss "$LOG_PATH_FROM_PRISM/t=$1_median/explicit/ev_10_k_1E-8" > "$LOG_PATH_FROM_PRISM/t=$1_median/explicit/ev_10_k_1E-8"
./prism -explicit -epsilon 1e-5 -maxiters 100000000 -power -absolute -const timeout=$1,lambda=$lambda "$MODEL_PATH_FROM_PRISM/timeoutqueue.sm" -ss -exportss "$LOG_PATH_FROM_PRISM/t=$1_median/explicit/ev_10_k_1E-5" > "$LOG_PATH_FROM_PRISM/t=$1_median/explicit/ev_10_k_1E-5"
cd -

#write a readme file for explicit computations
touch readme.txt
echo "t=$1" >> readme.txt
echo "lambda=ln(2)/timeout" >> readme.txt
echo "n=10" >> readme.txt
echo "naming: ev/ph_n_k_epsilon" >> readme.txt
echo "steady state distributions using the GSMP (ctmc with phase type) explicit engine
for termination epsilon 1.0E-5 for phase type, and termination epsilon 1.0E-8 and 1.0E-6 for event. 
For each computation a full log file is also created with the extention .log" >> readme.txt

cd "../"
mkdir "hybrid"
cd "hybrid"

cd $PRISM_PATH_FROM_SCRIPT
#compute hybrid phase type
for k in 1 2 5 10 25 50 75 100 125 150 175 200 225 250 275 300 500 1000 2000
do
  ./prism -hybrid -epsilon 1e-5 -maxiters 100000000 -power -absolute -const k=$k,timeout=$1,lambda=$lambda "$MODEL_PATH_FROM_PRISM/queue_withptf_ctmc.sm" -ss -exportss "$LOG_PATH_FROM_PRISM/t=$1_median/hybrid/ph_10_${k}_1E-5" > "$LOG_PATH_FROM_PRISM/t=$1_median/hybrid/ph_10_${k}_1E-5.log"
done
cd -

#write a readme file for hybrid computations
touch readme.txt
echo "t=$1" >> readme.txt
echo "lambda=ln(2)/timeout" >> readme.txt
echo "n=10" >> readme.txt
echo "naming: ph_n_k_epsilon" >> readme.txt
echo "steady state distributions using the CTMC with phase type on hybrid engine with Power method
absolute termination criteria for termination epsilon 1.0E-5 for phase type." >> readme.txt


