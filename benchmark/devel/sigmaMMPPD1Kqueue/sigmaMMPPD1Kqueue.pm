fdctmc

// model specific constants
const int N = 6; // amount of MMPPs in the process
const int K = 20; // queue capacity

// transition costs
const double REJECT_COST = 1.0;

// rates
const double L2H_RATE = 0.01;// base rate at which MMPPs get from low traffic to high traffic
const double H2L_RATE = 0.1; // base rate at which MMPPs get from high traffic to low traffic
const double LOW_RATE = 0.2; // base low traffic rate at which customers are generated
const double HIGH_RATE= 1.0; // base high traffic rate at which customers are generated

rewards 
	[genLowReject]      true : REJECT_COST; // cost for rejecting a customer because of a full queue
	[genHighReject]     true : REJECT_COST; // cost for rejecting a customer because of a full queue
	[genCombinedReject] true: REJECT_COST; // cost for rejecting a customer because of a full queue
endrewards

module sigmaMMPPD1Kqueue

fdelay serviceTime = 1.0; // time it takes to serve a customer
		
	highTraffic : [0..N] init 0; // amount of MMPPs that are in high traffic mode. otherwise they are in low traffic mode.
	queueSize : [0..K] init 0; // amount of customers in the queue. 
	// DSPN comment : if queueSize = 0, then P4=0. else P4=1

	[lowToHigh] (highTraffic<N) -> (L2H_RATE * (N - highTraffic)): (highTraffic'=highTraffic+1);

	[highToLow] (highTraffic>0) -> (H2L_RATE * highTraffic): (highTraffic'=highTraffic-1);

	[genLowEnqueue] (highTraffic=0) & (queueSize<K) -> (LOW_RATE * (N - highTraffic)): (queueSize'=queueSize+1);

	[genHighEnqueue] (highTraffic=N) & (queueSize<K) -> (HIGH_RATE * highTraffic): (queueSize'=queueSize+1);

	[genCombinedEnqueue] (highTraffic>0) & ((highTraffic<N)) & (queueSize<K) -> ((LOW_RATE * (N - highTraffic)) + (HIGH_RATE * highTraffic)): (queueSize'=queueSize+1);

	[genLowReject] (highTraffic=0) & (queueSize=K) -> (LOW_RATE * (N - highTraffic)): true; // nothing changes

	[genHighReject] (highTraffic=N) & (queueSize=K) -> (HIGH_RATE * highTraffic): true; // nothing changes

	[genCombinedReject] (highTraffic>0) & ((highTraffic<N)) & (queueSize=K) -> ((LOW_RATE * (N - highTraffic)) + (HIGH_RATE * highTraffic)): true; // nothing changes

	[serve] (queueSize>0) --serviceTime-> (queueSize'=queueSize-1);

endmodule
