@ECHO OFF
REM Asks the user for a new model name, and then creates the necessary devel skeleton for it.
ECHO What is the name of the new model you wish to create?
SET /P modelName=
IF "%modelName%" == "" (
ECHO Cannot create a model without a name.
PAUSE
EXIT
)
CD ..
IF NOT EXIST devel (
ECHO The devel directory does not exist.
PAUSE
EXIT
)
CD devel
IF EXIST %modelName% (
ECHO Model %modelName% already exists.
PAUSE
EXIT
)
MKDIR %modelName%
TYPE NUL >%modelName%/%modelName%.pm
TYPE NUL >%modelName%/%modelName%.xpn
TYPE NUL >%modelName%/%modelName%README.txt
(
  ECHO COMMENTARY:
  ECHO //TODO:
  ECHO:
  ECHO MODIFIABLE PARAMETERS:
  ECHO //TODO:
  ECHO:
  ECHO DSPN EXPLANATION:
  ECHO //TODO:
  ECHO:
  ECHO MODEL OPTIMAL VALUE PROBLEM:
  ECHO //TODO:
  ECHO:
  ECHO DATE AND AUTHOR:
  ECHO //TODO:
  ECHO:
  ECHO ORIGINAL MODEL SOURCE: 
  ECHO //TODO:
) >%modelName%/%modelName%README.txt
(
  ECHO fdctmc
  ECHO:
  ECHO //model specific constants
  ECHO const int CAPACITY = 8; //example model specific constant
  ECHO:
  ECHO //cost/reward constants in states
  ECHO const double ACTIVE_COST = 300.0; //example state cost
  ECHO:
  ECHO //cost/reward constants for transitions
  ECHO const double ACTIVATE_T_COST = 300.0; //example transition const
  ECHO:
  ECHO rewards
  ECHO //rewards
  ECHO 	[activate] true : ACTIVATE_T_COST; //example transition reward/cost
  ECHO 	powerState=2 : ACTIVE_COST; //example state reward/cost
  ECHO endrewards
  ECHO:
  ECHO //rate constants
  ECHO const double ARRIVAL_RATE = 0.0045; // example rate
  ECHO:
  ECHO module %modelName%
  ECHO:
  ECHO //fdelays
  ECHO fdelay serviceTime = 60.0; // example fdelay
  ECHO:
  ECHO //states
  ECHO 	buffer: [0..CAPACITY] init 0; // example state
  ECHO:
  ECHO //transitions
  ECHO 	[activate] ^(powerState^=1^) ^& ^(buffer^>0^) ^-^-activationTime^-^> ^(powerState^'^=2^); //example fdelay transition
  ECHO:
  ECHO 	[generate] ^(buffer^<CAPACITY^) -^> ARRIVAL_RATE: ^(buffer^'^=buffer+1^); //example  exponential transition
  ECHO:
  ECHO endmodule
) >%modelName%/%modelName%.pm
ECHO Created a new skeleton for model %modelName% in directory devel. 
ECHO Please implement it.
PAUSE