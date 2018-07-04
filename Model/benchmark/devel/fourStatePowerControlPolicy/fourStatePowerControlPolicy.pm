fdctmc

// model specific constants
const int CAPACITY = 8;	//amount of requests we can store in the buffer at a time

// costs in states
const double ACTIVE_COST  =300.0; // cost for being in an active state (idle is an active state too)
const double STANDBY_COST =180.0; // cost for being in a standby state
const double NAP_COST      =30.0; // cost for being in a sleeping state
const double POWERDOWN_COST =3.0; // cost for being in a powerdown state

// transition costs
const double ACTIVATE_T_COST=300.0; // cost for activate transition
const double RESYNC1_T_COST  =240.0; // cost for awakening from standby state
const double RESYNC2_T_COST  =165.0; // cost for awakening from sleep state
const double RESYNC3_T_COST  =152.0; // cost for awakening from powerdown state

// rates
const double ARRIVAL_RATE = 0.0045;  // rate of request arrivals in nanoseconds

rewards 
	[activate] true : ACTIVATE_T_COST; 
	[resync1] true : RESYNC1_T_COST; 
	[resync2] true : RESYNC2_T_COST; 
	[resync3] true : RESYNC3_T_COST; 
	powerState=4 : ACTIVE_COST; 
	powerState=3 : ACTIVE_COST; 
	powerState=2 : STANDBY_COST; 
	powerState=1 : NAP_COST; 
	powerState=0 : POWERDOWN_COST; 
endrewards

module fourStatePowerControlPolicy

fdelay serviceTime    =60.0;  // time to service a request in nanoseconds
fdelay activationTime =60.0;  // time to go from idle to active state in nanoseconds (being able to start serving requests after being idle)
fdelay standbyTime    =20.0;  // time spent in idle to go to standby in nanoseconds
fdelay sleepTime      =50.0;  // time spent in standby to go to sleep in nanoseconds
fdelay powerdownTime=3000.0;  // time spent in sleep to go into powerdown in nanoseconds
fdelay resync1Time     =6.0;  // time it takes to awaken from standby state in nanoseconds
fdelay resync2Time    =60.0;  // time it takes to awaken from sleep state in nanoseconds
fdelay resync3Time  =6000.0;  // time it takes to awaken from powerdown state in nanoseconds


	buffer: [0..CAPACITY] init 0; // amount of requests in the buffer
	powerState: [0..4] init 3; // ordered - smaller number means less power used. 0- powerdown, 1-sleep, 2-standby, 3- idle, 4-active

	[generate] (buffer<CAPACITY) -> ARRIVAL_RATE: (buffer'=buffer+1);

	[activate] (powerState=3) & (buffer>0) --activationTime-> (powerState'=4);

	[service] (powerState=4) & (buffer>1) --serviceTime-> (buffer'=buffer-1);

	[serviceAndRest] (powerState=4) & (buffer=1) --serviceTime-> (buffer'=buffer-1) & (powerState'=3);
//standby
	[standby] (powerState=3) & (buffer=0) --standbyTime-> (powerState'=2);

	[resync1] (powerState=2) & (buffer>0) --resync1Time-> (powerState'=3);
//sleep
	[sleep] (powerState=2) & (buffer=0) --sleepTime-> (powerState'=1);

	[resync2] (powerState=1) & (buffer>0) --resync2Time-> (powerState'=3);
//powerdown
	[powerdown] (powerState=1) & (buffer=0) --powerdownTime-> (powerState'=0);

	[resync3] (powerState=0) & (buffer>0) --resync3Time-> (powerState'=3);


endmodule

