fdctmc

//model specific constants
const int K = 2; // number of slots in the queue

// transition costs
const double REJECT_COST=1.0; // cost for rejecting an arrival (queue full)

rewards //costs for rejecting arrivals
	[reject] true : REJECT_COST; 
endrewards

// rates
const double ARRIVAL = 0.9; // effective arrival rate either multiplied by 0.5 or 1.5 depending on highTraffic marking.
const double MORE = 1.0;
const double LESS = 1.0;

module lowhighMMPPD22queue

fdelay service1 = 1.0;   //time required to serve arrivals in station 1
fdelay service2 = 1.0;   //time required to serve arrivals in station 2
		
	station1busy: [0..1] init 0; // station 1. 1-busy,0-idle 
	station2busy: [0..1] init 0; // station 2. 1-busy,0-idle 
	queueCapacity: [0..K] init K; // amount of free slots in the queue
	highTraffic: [0..1] init 1; // 1-high, 0-low

	[reject] (queueCapacity=0) -> (ARRIVAL * (0.5 + highTraffic)): (queueCapacity'=queueCapacity); //nothing happens

	[accept1First] (queueCapacity=K) & (station1busy=0) -> (0.5 * (ARRIVAL * (0.5 + highTraffic))): (queueCapacity'=queueCapacity-1) & (station1busy'=1); // we deal with nondeterminism using weights. If both stations are free we give them equal probability
	//there is concurrency here, because both stations are idle
	[accept2First] (queueCapacity=K) & (station2busy=0) -> (0.5 * (ARRIVAL * (0.5 + highTraffic))): (queueCapacity'=queueCapacity-1) & (station2busy'=1); // we deal with nondeterminism using weights. If both stations are free we give them equal probability

	[accept1Second] (queueCapacity=K-1) & (station1busy=0) -> (ARRIVAL * (0.5 + highTraffic)): (queueCapacity'=queueCapacity-1) & (station1busy'=1);
	// no concurrency, because one station is busy
	[accept2Second] (queueCapacity=K-1) & (station2busy=0) -> (ARRIVAL * (0.5 + highTraffic)): (queueCapacity'=queueCapacity-1) & (station2busy'=1);

	[serve1last] (station1busy=1) --service1-> (station1busy'=0) & (queueCapacity'=queueCapacity+1); 

	[serve2last] (station2busy=1) --service2-> (station2busy'=0) & (queueCapacity'=queueCapacity+1);

	[lessBursty] (highTraffic=1) -> LESS: (highTraffic'=0);

	[moreBursty] (highTraffic=0) -> MORE: (highTraffic'=1);

endmodule

