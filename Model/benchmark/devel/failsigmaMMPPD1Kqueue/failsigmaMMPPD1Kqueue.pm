fdctmc

// model specific constants
const int N = 3; // amount of MMPPs in the process
const int K = 10; // queue capacity

// transition costs
const double REJECT_COST = 1.0;

// rates
const double L2H_RATE = 0.01;// base rate at which MMPPs get from low traffic to high traffic
const double H2L_RATE = 1.0; // base rate at which MMPPs get from high traffic to low traffic
const double LOW_RATE = 0.2; // base low traffic rate at which customers are generated
const double HIGH_RATE= 0.5; // base high traffic rate at which customers are generated
const double FAIL_RATE= 0.05; // rate at which the queueing system fails

rewards 
	[genReject] true : REJECT_COST; // cost for rejecting a customer because of a full queue
endrewards

module failsigmaMMPPD1Kqueue
//these are not concurrent
fdelay serviceTime = 1.0; // time it takes to serve a customer
fdelay repairTime = 10.0; // time it takes to repair the system so that we can start serving customers again

		
	highTraffic : [0..N] init 0; // amount of MMPPs that are in high traffic mode. otherwise they are in low traffic mode.
	queueSize : [0..K] init 0; // amount of customers in the queue. 
	// DSPN comment : if queueSize = 0, then P4=0. else P4=1
	failed : [0..1] init 1; //1-failed, 0-OK. initially failed!

	[lowToHigh] (highTraffic<N) -> (L2H_RATE * (N - highTraffic)): (highTraffic'=highTraffic+1);

	[highToLow] (highTraffic>0) -> (H2L_RATE * highTraffic): (highTraffic'=highTraffic-1);

	[genEnqueue] (queueSize<K) -> ((LOW_RATE * (N - highTraffic)) + (HIGH_RATE * highTraffic)): (queueSize'=queueSize+1);

	[genReject] (highTraffic<N) & (queueSize=K) -> ((LOW_RATE * (N - highTraffic)) + (HIGH_RATE * highTraffic)): true; // nothing changes

	[serve] (queueSize>0) & (failed=0) --serviceTime-> (queueSize'=queueSize-1);

	[fail] (failed=0) -> FAIL_RATE: (failed'=1);

	[repair] (failed=1) --repairTime-> (failed'=0);

endmodule
