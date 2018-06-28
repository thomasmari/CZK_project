#PARAMETERS
#$1 t(s) the timeout
#$2 kinf_of_lambda according to t in {regular,median} regular mean lambda = 1/t, and median means t will be the median value of exp(lambda)
#$3 epsilon you want 
#$4 the engine in {event,explicit,hybrid,storm}
#$5 kind_of_epsilon in {dynamic, constant} for dynamic you have eps_computation = eps/k 	NOT NEEDED FOR EVENT ENGINE 
#$6 the PH fitting parameter k 																NOT NEEDED FOR EVENT ENGINE
#compute steady state probabilities for various k values.
#This script must remain in CZK_project/Script !!!
# median means Lambda is derived as (ln 2 / timeout).

#Path Setting
PRISM_PATH_FROM_OUTPUT="../../../../prism-gsmp/prism/bin"
CLASSIC_PRISM_PATH_FROM_OUTPUT="../../../../prism-4.4-src/bin"
MODEL_PATH_FROM_PRISM="../../../CZK_project/Model"
MODEL_PATH_FROM_CLASSIC_PRISM="../../CZK_project/Model"
OUTPUT_PATH_FROM_PRISM="../../../CZK_project/Output"
OUTPUT_PATH_FROM_CLASSIC_PRISM="../../CZK_project/Output"

#Here you can set the sequence of k computed
sequence=$(seq 1 1 9; seq 10 10 90; seq 100 100 900; seq 1000 1000 4000; seq 5000 5000 50000);

#Help option
if [ "$1" == "help" ]; then
	echo '5 argument are expected :'
	echo '$1 is the the timeout in second, the one we choose to run tests was 0.1'
	echo '$2 kind_of_lambda according to t in {regular,median}'
	echo '   regular : lambda = 1/t'
	echo '   median : t will be the median value of the exponential distribution exp(lambda) (ln(2)/t)'
	echo '$3 is the the precision epsilon in [1-9]+{E-}[1-9]+ format, in prism it is the termination epsilon for power method, in storm it set the --epsilon option (1E-6 is the default value for both PRISM and Storm)'
	echo '$4 the engine in {event,explicit,hybrid,storm} that will do the computation'
	echo '   event is the ACTMC model checker'
	echo '   explicit is the ACTMC model checker for only CTMC model'
	echo '   hybrid is the PRISM model checker with hybrid engine'
	echo '   storm is the Storm model checker with sparse engine'	
	echo '$5 kind_of_epsilon in {dynamic, constant} for dynamic you have eps_computation = eps/k '
	echo '   constant : the precision epsilon will remain the same for every computations'
	echo '   dynamic : the precision epsilon will depend on k eps_computation = eps/k'
	echo 'Result :'
	echo 'It will compute logs and outputs for the specified parameters for a fixed range of k from 1 to 5000 with exponential steps'
	exit 1
	fi
	
#check parameter
reNum='^[-+]?[0-9]+\.?[0-9]*$'
if ! [[ $1 =~ $reNum ]]; then
  echo "Please specify number \"timeout\" as the first parameter!"
  exit 1
fi

if [ -z "$2" ]
  then
    echo "kind of lambda not supplied, choose in {regular,median}"
    exit 1
fi

if [ -z "$3" ]
  then
    echo "epsilon not supplied"
    exit 1
fi

if [ -z "$4"  ]
  then
    echo "engine not supplied, choose in {event,explicit,hybrid}"
    exit 1
fi

if [ -z "$5" ] && [ $4 != "event" ]
  then
    echo "kind_of_epsilon not supplied for other engine that event, choose in {dynamic,constant}"
    exit 1
fi

if [ -z "$6" ] && [ $4 != "event" ];
  then
    echo "PH fitting parameter k not supplied for other engine that event"
    exit 1
fi



#Constant computation
timeout="$1"			
kindOfLambda="$2" 								#Read lamda
epsilon=$(awk -v a="$3" 'BEGIN{print (a)}')	#Read epsilon
engine="$4"
k="$6"									#PH fitting parameter k
if [ -z "$5" ]
	then
		kindOfEpsilon="constant"
	else
		kindOfEpsilon="$5"
fi


#lambda and path setting
ln_2="0.6931471805599453094" #20 digits
if [ $kindOfLambda == "regular" ]; then
	lambda=$(echo "scale=20;1/$1" | bc)
elif [ $kindOfLambda == "median" ]; then
	lambda=$(echo "scale=20;${ln_2}/$1" | bc)
else
	exit 1
fi


path="t=${timeout}_${kindOfLambda}_${epsilon}_${kindOfEpsilon}"
echo lambda = $lambda
echo path = $path


#changing directory
cd '../Output'

mkdir $path
cd $path
if [ $engine == "event" ]; then
	mkdir "explicit"
	cd "explicit"
else
	mkdir $engine
	cd $engine
fi




#STARTING COMPUTATION


if [ $engine == "event" ]; then
	cd $PRISM_PATH_FROM_OUTPUT
	echo engine epsilon_computation
	#compute explicit event
	echo event $eps
	./prism -explicit -epsilon ${epsilon} -maxiters 100000000 -power -absolute -const timeout=$timeout,lambda=$lambda "$MODEL_PATH_FROM_PRISM/timeoutqueue.sm" -ss -exportss "$OUTPUT_PATH_FROM_PRISM/${path}/explicit/ev_10_k_${epsilon}" > "$OUTPUT_PATH_FROM_PRISM/${path}/explicit/ev_10_k_${epsilon}.log"
	cd -
	
elif [ $engine == "explicit" ]; then
	cd $PRISM_PATH_FROM_OUTPUT
	echo engine k     epsilon_computation epsilon 
	if [ $kindOfEpsilon == "dynamic" ]; then
		eps_k=$(awk -v e="$epsilon" -v k0="$k" 'BEGIN{print (e / k0)}')
	else
		eps_k=$epsilon
	fi
	echo explicit $k $eps_k eps=$epsilon 
	./prism -explicit -epsilon ${eps_k} -maxiters 100000000 -power -absolute -const k=$k,timeout=$timeout,lambda=$lambda "$MODEL_PATH_FROM_PRISM/queue_withptf_gsmp.sm" -ss -exportss "$OUTPUT_PATH_FROM_PRISM/${path}/${engine}/ph_10_${k}_${epsilon}" > "$OUTPUT_PATH_FROM_PRISM/${path}/${engine}/ph_10_${k}_${epsilon}.log"

	cd -
	#write a readme file for explicit computations
	touch readme.txt
	echo "t=$1" >> readme.txt
	echo "lambda=$lambda" >> readme.txt
	echo "n=10" >> readme.txt
	echo "naming: ev/ph_n_k_epsilon" >> readme.txt
	echo "steady state distributions using the GSMP (ctmc with phase type) explicit engine
	for termination epsilon 1.0E-5 for phase type, and termination epsilon 1.0E-8 and 1.0E-6 for event. 
	For each computation a full log file is also created with the extention .log" >> readme.txt

			
elif [ $engine == "hybrid" ]; then
	#~ cd $PRISM_PATH_FROM_OUTPUT
	cd $CLASSIC_PRISM_PATH_FROM_OUTPUT
	echo 	engine k 	epsilon_computation	epsilon 
	#compute hybrid phase type
	if [ $kindOfEpsilon == "dynamic" ]; then
		eps_k=$(awk -v e="$epsilon" -v k0="$k" 'BEGIN{print (e / k0)}')
	elif [ $kindOfEpsilon == "constant" ]; then
		eps_k=$epsilon
	else
		exit 1
	fi
	echo 	hybrid 	$k 	$eps_k 	$epsilon
	./prism -hybrid -epsilon ${eps_k} -maxiters 100000000 -power -absolute -const k=$k,timeout=$timeout,lambda=$lambda "$MODEL_PATH_FROM_CLASSIC_PRISM/queue_withptf_ctmc.sm" -ss -exportss "$OUTPUT_PATH_FROM_CLASSIC_PRISM/${path}/${engine}/ph_10_${k}_${epsilon}" > "$OUTPUT_PATH_FROM_CLASSIC_PRISM/${path}/${engine}/ph_10_${k}_${epsilon}.log"

	cd -
	#write a readme file for hybrid computations
	touch readme.txt
	echo "t=$1" >> readme.txt
	echo "lambda=ln(2)/timeout" >> readme.txt
	echo "n=10" >> readme.txt
	echo "naming: ph_n_k_epsilon" >> readme.txt
	echo "steady state distributions using the CTMC with phase type on hybrid engine with Power method
	absolute termination criteria for termination epsilon 1.0E-5 for phase type." >> readme.txt


elif [ $engine == "storm" ]; then
	#~ cd $PRISM_PATH_FROM_OUTPUT
	cd $CLASSIC_PRISM_PATH_FROM_OUTPUT
	echo	engine k	epsilon_computation	epsilon 
	#compute hybrid phase type
	if [ $kindOfEpsilon == "dynamic" ]; then
		eps_k=$(awk -v e="$epsilon" -v k0="$k" 'BEGIN{print (e / k0)}')
	elif [ $kindOfEpsilon == "constant" ]; then
		eps_k=$epsilon
	else
		exit 1
	fi
	echo storm $k $eps_k $epsilon
	storm --prism "$MODEL_PATH_FROM_CLASSIC_PRISM/queue_withptf_ctmc.sm" --prop "$MODEL_PATH_FROM_CLASSIC_PRISM/storm_prop.csl" -e sparse -pc --precision "$eps_k" --abstraction:precision "$eps_k" --constants k="$k",timeout="$timeout",lambda="$lambda" > "$OUTPUT_PATH_FROM_CLASSIC_PRISM/${path}/${engine}/ph_10_${k}_${epsilon}.log"

	cd -
	#write a readme file for hybrid computations
	touch readme.txt
	echo "t=$1" >> readme.txt
	echo "lambda=ln(2)/timeout" >> readme.txt
	echo "n=10" >> readme.txt
	echo "naming: ph_n_k_epsilon" >> readme.txt
	echo "steady state distributions using the CTMC with phase type on hybrid engine with Power method
	absolute termination criteria for termination epsilon 1.0E-5 for phase type." >> readme.txt
fi
