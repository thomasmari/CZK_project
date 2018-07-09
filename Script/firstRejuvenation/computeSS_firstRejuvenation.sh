#PARAMETERS
#$1 epsilon you want 
#$2 the engine in {event,explicit,hybrid,storm}
#$3 kind_of_epsilon in {dynamic, constant} for dynamic you have eps_computation = eps/k 	NOT NEEDED FOR EVENT ENGINE 
#$4 the PH fitting parameter k 																NOT NEEDED FOR EVENT ENGINE
#This script must remain in CZK_project/Script !!!

#Path Setting
PRISM_PATH_FROM_RESULTS="../../../../prism-gsmp/prism/bin"
CLASSIC_PRISM_PATH_FROM_RESULTS="../../../../prism-4.4-src/bin"
MODEL_PATH_FROM_PRISM="../../../CZK_project/Model/benchmark/devel/firstRejuvenation"
MODEL_PATH_FROM_CLASSIC_PRISM="../../CZK_project/Model/benchmark/devel/firstRejuvenation"
OUTPUT_PATH_FROM_PRISM="../../../CZK_project/Output"
OUTPUT_PATH_FROM_CLASSIC_PRISM="../../CZK_project/Output"

#Help option
if [ "$1" == "help" ]; then
	echo '$1 is the the precision epsilon in [1-9]+{E-}[1-9]+ format, in prism it is the termination epsilon for power method, in storm it set the --epsilon option (1E-6 is the default value for both PRISM and Storm)'
	echo '$2 the engine in {event,explicit,hybrid,storm} that will do the computation'
	echo '   event is the ACTMC model checker'
	echo '   explicit is the ACTMC model checker for only CTMC model'
	echo '   hybrid is the PRISM model checker with hybrid engine'
	echo '   storm is the Storm model checker with sparse engine'	
	echo '$3 kind_of_epsilon in {dynamic, constant} for dynamic you have eps_computation = eps/k '
	echo '   constant : the precision epsilon will remain the same for every computations'
	echo '   dynamic : the precision epsilon will depend on k eps_computation = eps/(k**3)'
	echo '$4 PH fitting parameter k'
	echo 'Result :'
	echo 'It will compute logs and outputs for the specified parameters for a fixed range of k from 1 to 5000 with exponential steps'
	exit 1
	exit 1
	fi
	
#check parameter
if [ -z "$1" ]
  then
    echo "epsilon not supplied amongs $1 $2 $3 $4"
    exit 1
elif [ -z "$2"  ]
  then
    echo "engine not supplied, choose in {event,explicit,hybrid}"
    exit 1
elif [ -z "$3" ] && [[ $2 != event ]]
  then
    echo "kind_of_epsilon not supplied for other engine that event, choose in {dynamic,constant}"
    exit 1
elif [ -z "$4" ] && [[ $2 != "event" ]]
  then
    echo "PH fitting parameter k not supplied for other engine that event amongs $1 $2 $3 $4"
    exit 1
fi



#Constant computation
epsilon=$(awk -v a="$1" 'BEGIN{print (a)}')	#Read epsilon
engine="$2"
k="$4"									#PH fitting parameter k
if [ -z "$3" ]
	then
		kindOfEpsilon="constant"
	else
		kindOfEpsilon="$3"
fi


path="firstRejuvenation_${epsilon}_${kindOfEpsilon}"

#changing directory
cd '../../Output'

mkdir $path
cd $path
if [ $engine == "event" ]; then
	folder="explicit"
else
	folder=$engine
fi
mkdir $folder
cd $folder


#choosing filename
if [ $engine == "event" ]; then
	file_name="ev_k_${epsilon}"
	
else
	file_name="ph_${k}_${epsilon}"
fi

#STARTING COMPUTATION
if [ $kindOfEpsilon == "dynamic" ]; then
	eps_k=$(awk -v e="$epsilon" -v k0="$k" 'BEGIN{print (e / k0)}')
elif [ $kindOfEpsilon == "constant" ]; then
	eps_k=$epsilon
else
	exit 1
fi


if [ $engine == "event" ]; then
	full_file_path="$OUTPUT_PATH_FROM_PRISM/${path}/${folder}/${file_name}"
	cd $PRISM_PATH_FROM_RESULTS
	echo event $epsilon
	./prism -explicit -epsilon ${epsilon} -maxiters 100000000 -power -absolute "$MODEL_PATH_FROM_PRISM/firstRejuvenation_ACTMC.pm" -ss -exportss $full_file_path > $full_file_path".log"
	
elif [ $engine == "explicit" ]; then
	full_file_path="$OUTPUT_PATH_FROM_PRISM/${path}/${folder}/${file_name}"
	cd $PRISM_PATH_FROM_RESULTS
	echo explicit $k $eps_k eps=$epsilon 
	./prism -explicit -epsilon ${eps_k} -maxiters 100000000 -power -absolute -const k=$k "$MODEL_PATH_FROM_PRISM/firstRejuvenation_CTMC.pm" -ss -exportss $full_file_path > $full_file_path".log"
	
elif [ $engine == "hybrid" ]; then	
	full_file_path="$OUTPUT_PATH_FROM_CLASSIC_PRISM/${path}/${folder}/${file_name}"
	cd $CLASSIC_PRISM_PATH_FROM_RESULTS
	echo 	hybrid 	$k 	$eps_k 	$epsilon
	./prism -hybrid -epsilon ${eps_k} -maxiters 100000000 -power -absolute -const k=$k "$MODEL_PATH_FROM_CLASSIC_PRISM/firstRejuvenation_CTMC.pm" -ss -exportss $full_file_path > $full_file_path".log"

elif [ $engine == "storm" ]; then
	full_file_path="$OUTPUT_PATH_FROM_STORM/${path}/${folder}/${file_name}"
	echo storm $k $eps_k $epsilon NOT IMPLEMETED
	storm --prism "$MODEL_PATH_FROM_PRISM/firstRejuvenation_CTMC.pm" --prop "$MODEL_PATH_FROM_CLASSIC_PRISM/storm_prop.csl" -e sparse -pc --precision "$eps_k" --abstraction:precision "$eps_k" --constants k="$k" > $full_file_path".log"
	
fi
echo "$(pwd)"
