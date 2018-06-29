fdctmc

// model specific constants
const int CAPACITY = 8;	//amount of requests we can store in the buffer at a time

// costs in states
const double ACTIVE_COST =300.0; // cost for being in an active OR idle state
const double NAP_COST     =30.0; // cost for being in a sleeping state

// transition costs
const double ACTIVATE_T_COST=300.0; // cost for activate transition
const double AWAKEN_T_COST  =165.0; // cost for awaken transition

// rates
const double ARRIVAL_RATE = 0.0045;  // rate of request arrivals in nanoseconds

rewards 
	[activate] true : ACTIVATE_T_COST; 
	[awaken] true : AWAKEN_T_COST; 
	powerState=2 : ACTIVE_COST; 
	powerState=1 : ACTIVE_COST; 
	powerState=0 : NAP_COST; 
endrewards

module twoStatePowerControlPolicy

fdelay serviceTime   =60.0;  // time to service a request in nanoseconds
fdelay activationTime=60.0;  // time to go from idle to active state in nanoseconds
fdelay sleepTime     =50.0;  // time spent in idle to go to sleep in nanoseconds
fdelay awakenTime   = 60.0;  // time it takes to wake up from sleeping when a request arrives in nanoseconds


	buffer: [0..CAPACITY] init 0; // amount of requests in the buffer
	powerState: [0..2] init 1; // ordered - smaller number means less power used. 0- sleeping, 1-idle, 2-active

	[generate] (buffer<CAPACITY) -> ARRIVAL_RATE: (buffer'=buffer+1);

	[activate] (powerState=1) & (buffer>0) --activationTime-> (powerState'=2);

	[service] (powerState=2) & (buffer>1) --serviceTime-> (buffer'=buffer-1);

	[serviceAndRest] (powerState=2) & (buffer=1) --serviceTime-> (buffer'=buffer-1) & (powerState'=1);

	[sleep] (powerState=1) & (buffer=0) --sleepTime-> (powerState'=0);

	[awaken] (powerState=0) & (buffer>0) --awakenTime-> (powerState'=1);


endmodule

