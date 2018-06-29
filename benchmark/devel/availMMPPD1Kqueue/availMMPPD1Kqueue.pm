fdctmc

//model specific constants
const int K = 5; // number of slots in the queue
const int N = 4; // levels of burstiness
const double LAMBDA = 0.9; // effective arrival rate

// transition costs
const double REJECT_COST=1.0; // cost for rejecting an arrival (queue full)

rewards //costs for rejecting arrivals
	[reject] true : REJECT_COST; 
endrewards

// rates
const double ARRIVAL = (LAMBDA / (N-1)); //arrival rate for each level of burstiness
const double MORE = 1.0;
const double LESS = 1.0;
const double FAIL = 1/500.0; // rate of failure

module availMMPPD1Kqueue

fdelay service = 1.0;   //time required to serve arrivals in station 1
fdelay repair = 15.0; // time required to repair after a failure
		
	queueCapacity: [0..K] init K; // amount of free slots in the queue
	burstiness: [0..N] init N; // level of burstiness. 
	avail: [0..1] init 1; // availability. 1-up, 0-down
	
	[reject] (queueCapacity=0) -> (0.1 + (ARRIVAL * burstiness)): (queueCapacity'=queueCapacity); //nothing happens

	[accept] (queueCapacity>0) -> (0.1 + (ARRIVAL * burstiness)): (queueCapacity'=queueCapacity-1);

	[serve] (queueCapacity<K) & (avail=1) --service-> (queueCapacity'=queueCapacity+1);


	[lessBursty] (burstiness>0) -> LESS: (burstiness'=burstiness-1);

	[moreBursty] (burstiness<N) -> MORE: (burstiness'=burstiness+1);

	[fail] (avail=1) -> FAIL: (avail'=0);

	[repair] (avail=0) --repair-> (avail'=1);

endmodule

