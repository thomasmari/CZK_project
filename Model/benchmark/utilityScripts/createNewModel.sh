#!/bin/bash
# First argument is the name of the new model skeleton to create in devel directory.
# The script creates the necessary devel skeleton for it.
if [ -z "${1}" ]; then
    echo "The model must have a name. The first command line variable is the model name."
	exit
fi
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd "$SCRIPTPATH"
cd ..
if [ ! -d devel ]; then 
  echo "Local directory devel does not exist."
  exit
fi
cd devel
if [ -d "${1}" ]; then 
  echo "Model ${1} already exists in the devel directory."
  exit
fi
mkdir "${1}"
cd "${1}"
touch "${1}.pm"
touch "${1}.xpn"
touch "${1}README.txt"

echo "COMMENTARY:" >> "${1}README.txt"
echo "//TODO:" >> "${1}README.txt"
echo "" >> "${1}README.txt"
echo "MODIFIABLE PARAMETERS:" >> "${1}README.txt"
echo "//TODO:" >> "${1}README.txt"
echo "" >> "${1}README.txt"
echo "DSPN EXPLANATION:" >> "${1}README.txt"
echo "//TODO:" >> "${1}README.txt"
echo "" >> "${1}README.txt"
echo "MODEL OPTIMAL VALUE PROBLEM:" >> "${1}README.txt"
echo "//TODO:" >> "${1}README.txt"
echo "" >> "${1}README.txt"
echo "DATE AND AUTHOR:" >> "${1}README.txt"
echo "//TODO:" >> "${1}README.txt"
echo "" >> "${1}README.txt"
echo "ORIGINAL MODEL SOURCE: " >> "${1}README.txt"
echo "//TODO:" >> "${1}README.txt"

echo "fdctmc" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "//model specific constants" >> "${1}.pm"
echo "const int CAPACITY = 8; //example model specific constant" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "//cost/reward constants in states" >> "${1}.pm"
echo "const double ACTIVE_COST = 300.0; //example state cost" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "//cost/reward constants for transitions" >> "${1}.pm"
echo "const double ACTIVATE_T_COST = 300.0; //example transition const" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "rewards" >> "${1}.pm"
echo  "//rewards" >> "${1}.pm"
echo "	[activate] true : ACTIVATE_T_COST; //example transition reward/cost" >> "${1}.pm"
echo "	powerState=2 : ACTIVE_COST; //example state reward/cost" >> "${1}.pm"
echo "endrewards" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "//rate constants" >> "${1}.pm"
echo "const double ARRIVAL_RATE = 0.0045; // example rate" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "module ${1}" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "//fdelays" >> "${1}.pm"
echo "fdelay serviceTime = 60.0; // example fdelay" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "//states" >> "${1}.pm"
echo "	buffer: [0..CAPACITY] init 0; // example state" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "//transitions" >> "${1}.pm"
echo "	[activate] (powerState=1) & (buffer>0) --activationTime-> (powerState'=2); //example fdelay transition" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "	[generate] (buffer<CAPACITY) -> ARRIVAL_RATE: (buffer'=buffer+1); //example  exponential transition" >> "${1}.pm"
echo "" >> "${1}.pm"
echo "endmodule" >> "${1}.pm"

echo "Created a new skeleton for model ${1} in directory devel."
echo "Please implement it."
