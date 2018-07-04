fdctmc

// costs in states
const double MEMBUS_UNUSED=1.0; // cost for not currently using the bus to serve memory access requests

// model specific constants
const int NUM_CPUS = 4; // amount of processors in the system

// rates
const double MEM_ACC_REQ_RATE = 2500.0; // rate at which a processor generates memory access requests
const double FAIL_RATE           = 0.000002; // rate at which a processor may fail
const double REPAIR_RATE         = 0.000277; // rate at which a failed processor gets repaired

rewards 
	busAvail!=1 : MEMBUS_UNUSED; // In effect when there are no requests to be served or when the bus is used for reconfiguration
endrewards

module multiprocessorSystem

fdelay memAccessTime            = 0.0001; // time it takes to access the memory
fdelay failReconfigurationTime  = 60.0; //time it takes to reconfigure after processor failure
fdelay repairReconfigurationTime= 60.0; //time it takes to reconfigure after processor repair
		
	running : [0..NUM_CPUS] init NUM_CPUS; // amount of processors that are running and have no memory access requests yet
	waiting : [0..NUM_CPUS] init 0; // amount of processors that have a memory access request and are waiting for the bus to become available
	failedQueue: [0..NUM_CPUS] init 0; // amount of processors that have failed and are awaiting reconfiguration
	failedRepair : [0..NUM_CPUS] init 0; // amount of processors that are "out" of the system after reconfiguration and need repair/replacement
	repairedQueue: [0..NUM_CPUS] init 0; // amount of processors that are freshly repaired, need reconfiguration and are waiting for the bus to become available
	busAvail: [0..3] init 0; // bus availability. 0-available, 1-not available, used for memory access request, 2-not available, used for fail reconfiguration, 3- not available, used for repaired reconfiguration

//MEM ACCESS REQUESTS ARRIVAL

	//running processor generates a memory access request while the bus is available
	[genRequestNoWaiting] (running>0) & (busAvail=0)  -> (MEM_ACC_REQ_RATE * running): (running'=running - 1) & (busAvail'=1);

	//running processor generates a memory access request while the bus is serving another request
	[genRequest] (running>0) & (busAvail=1) -> (MEM_ACC_REQ_RATE * running): (running'=running - 1) & (waiting'=waiting + 1);
//MEM ACCESS REQUEST SERVICE

	//serves the (currently) last memory access request of the system and makes the bus available afterwards
	[memAccessLast] (busAvail=1) & (waiting=0) & (failedQueue=0) & (repairedQueue=0)  --memAccessTime-> (running'=running + 1) & (busAvail'=0);

	//serves a memory access request of the system and immediately starts serving another afterwards
	[memAccess] (busAvail=1) & (waiting>0) & (failedQueue=0) & (repairedQueue=0) --memAccessTime-> (running'=running + 1) & (waiting'=waiting - 1);

	//serves a memory access request of the system from the queue and starts a failure reconfiguration afterwards
	[memAccessStartFailReconfiguration] (busAvail=1) & (failedQueue>0) --memAccessTime-> (running'=running + 1) & (busAvail'=2);

	//serves a memory access request of the system from the queue and starts repaired reconfiguration afterwards
	[memAccessStartRepairReconfiguration] (busAvail=1) & (failedQueue=0) & (repairedQueue>0) --memAccessTime-> (running'=running + 1) & (busAvail'=3);
//FAILURES

	//running processors fail while the bus is unused
	[failRunningUnused] (running>0) & (busAvail=0) -> (FAIL_RATE * running): (running'=running - 1) & (failedQueue'=failedQueue + 1) & (busAvail'= 2);

	//running processors fail while the bus is used for a memory request
	[failRunningUsed] (running>0) & (busAvail=1) -> (FAIL_RATE * running): (running'=running - 1) & (waiting'=waiting + 1) & (failedQueue'=failedQueue + 1) & (busAvail'= 2);

	//running processors fail while the bus is used for reconfiguration
	[failRunningWasted] (running>0) & (busAvail>1) -> (FAIL_RATE * running): (running'=running - 1) & (failedQueue'=failedQueue + 1) ;

	//waiting processors fail while the bus is used for a memory request OR processor currently accessing the memory fails
	[failWaitingUsed] (waiting>0) & (busAvail=1) -> (FAIL_RATE * (waiting + busAvail)): (failedQueue'=failedQueue + 1) & (busAvail'= 2);

	//waiting processors fail while the bus is used for reconfiguration
	[failWaitingWasted] (waiting>0) & (busAvail>1) -> (FAIL_RATE * waiting): (waiting'=waiting - 1) & (failedQueue'=failedQueue + 1);

	//processor currently accessing the memory fails
	[failAccessing] (waiting=0) & (busAvail=1) -> (FAIL_RATE): (failedQueue'=failedQueue + 1) & (busAvail'= 2);
//FAILURE RECONFIGURATION

	//system reconfiguration after a processor fails and at least one more fails meanwhile
	[failReconfiguration] (busAvail=2) & (failedQueue>1) -- failReconfiguratioTime-> (failedQueue'=failedQueue - 1) & (failedRepair'= failedRepair + 1);

	//system reconfiguration after a single processor fails and no others have failed meanwhile - releases the bus
	[failReconfigurationLast] (busAvail=2) & (failedQueue=1) & (waiting=0) & (repairedQueue=0) --failReconfigurationTime-> (busAvail'=0) & (failedQueue'=failedQueue - 1) & (failedRepair'= failedRepair + 1);

	//system reconfiguration after a single processor fails and no others have failed meanwhile - gives the bus to mem service requests
	[failReconfigurationLastMem] (busAvail=2) & (failedQueue=1) & (waiting>0) & (repairedQueue=0) --failReconfigurationTime-> (busAvail'=1) & (waiting'=waiting - 1) & (failedQueue'=failedQueue - 1) & (failedRepair'= failedRepair + 1);

	//system reconfiguration after a single processor fails and no others have failed meanwhile - gives the bus to repair reconfiguration
	[failReconfigurationLastRec] (busAvail=2) & (failedQueue=1) & (repairedQueue>0) --failReconfigurationTime-> (busAvail'=3) & (failedQueue'=failedQueue - 1) & (failedRepair'= failedRepair + 1);
//REPAIR

	//processor repair with reconfiguration starting right afterwards - seizes the bus
	[repairAndStartReconfiguration] (failedRepair>0) & (busAvail=0) -> (REPAIR_RATE * failedRepair): (busAvail'=3) & (failedRepair'= failedRepair - 1) & (repairedQueue'=repairedQueue + 1);

	//processor repair with reconfiguration happening later, once the bus is free
	[repair] (failedRepair>0) & (busAvail!=0) -> (REPAIR_RATE * failedRepair): (failedRepair'= failedRepair - 1) & (repairedQueue'=repairedQueue + 1);

//REPAIRED RECONFIGURATION

	//system reconfiguration after a processor was repaired and at least one more needs reconfiguration meanwhile
	[repairedReconfiguration] (busAvail=3) & (repairedQueue>1) --repairReconfigurationTime-> (repairedQueue'=repairedQueue - 1) & (running'=running + 1);

	//system reconfiguration after a processor was repaired and no other processor was repaired meanwhile - releases the bus
	[repairedReconfigurationLast] (busAvail=3) & (repairedQueue=1) & (waiting=0) & (failedQueue=0) --repairReconfigurationTime-> (busAvail'=0) & (repairedQueue'=repairedQueue - 1) & (running'=running + 1);

	//system reconfiguration after a processor was repaired and no other processor was repaired meanwhile - gives the bus to mem service reqeuests
	[repairedReconfigurationLastMem]  (busAvail=3) & (repairedQueue=1) & (waiting>0) & (failedQueue=0) --repairReconfigurationTime-> (busAvail'=1) & (waiting'=waiting - 1) & (repairedQueue'=repairedQueue - 1) & (running'=running + 1);

	//system reconfiguration after a processor was repaired and no other processor was repaired meanwhile - gives the bus to failure reconfiguration
	[repairedReconfigurationLastFail]  (busAvail=3) & (repairedQueue=1) & (failedQueue>0) --repairReconfigurationTime->  (busAvail'=2) & (repairedQueue'=repairedQueue - 1) & (running'=running + 1);

endmodule
