fdctmc

// model specific constants
const int M = 4; // amount of modules
const double ALPHA = 0.14; // probability of a previously operable module to fail after the detection interval
const double BETA = 0.017; // probability of a failing module not to need a repair yet after the detection interval
const double DECISION_RATE = 10000; // arbitrary value to use for decisions. Designed so that ((1/DECISION_RATE * M) << detectionTime)

// rates
const double FAIL_RATE   = 0.000001; 
const double REPAIR_RATE = 0.001; 

module faultTolerantClockingSystem

fdelay detectionTime      = 4;  // detection interval duration
fdelay nonDetectionTime  = 20; // nondetection interval duration
		
	operable : [0..M] init M; // amount of modules that are fully functional
	failing : [0..M] init 0; // amount of modules that are either failing or unknown
	failed : [0..M] init 0; // amount of modules that need a repair
	//F-future (here we decide what is going to happen next with the modules). Also while here the modules cannot fail.
	F_operable : [0..M] init 0; // amount of modules that will be fully functional
	F_failing : [0..M] init 0; // amount of modules that will be either failing or unknown
	F_failed : [0..M] init 0; // amount of modules that will need a repair
	//detection interval boolean state
	detection : [0..1] init 0; // 0-nondetection interval, 1-detection interval
	
//basic transitions
	[fail] (operable>0) -> (FAIL_RATE * operable): (operable'=operable-1) & (failing'=failing+1);

	[repair] (failed>0) -> (REPAIR_RATE * failed): (failed'=failed-1) & (operable'=operable+1);

	[beginDetection] (detection=0) --nonDetectionTime-> (detection'=1);

	[endDetection] (detection=1) --detectionTime-> (detection'=0) & (operable'=F_operable) & (failing'=F_failing) & (failed'=F_failed) & (F_operable'=0) & (F_failing'=0) & (F_failed'=0);
//decision transitions
	[operableToF_operable] (detection=1) & (operable>0) -> (DECISION_RATE * (1 - ALPHA)): (operable'=operable-1) & (F_operable'=F_operable+1);

	[operableToF_failed] (detection=1) & (operable>0) -> (DECISION_RATE * (ALPHA)): (operable'=operable-1) & (F_failed'=F_failed+1);

	[failingToF_failing] (detection=1) & (failing>0) -> (DECISION_RATE * (BETA)): (failing'=failing-1) & (F_failing'=F_failing+1);

	[failingToF_failed] (detection=1) & (failing>0) -> (DECISION_RATE * (1 - BETA)): (failing'=failing-1) & (F_failed'=F_failed+1);

endmodule
