fdctmc

// model specific constants
const int BUFFER_SPACES= 10;	//amount of buffers that may be used to service requests

// cost in states
const double UNAVAILABLE_COST=20.0;
const double DEGRADED_COST=0.5;

// rates
const double DEGRADATION_RATE = 1/14400.0;  //converted to minutes
const double FAILURE_RATE = 1/43200.0;     //converted to minutes
const double HIGH_RATE = 1/4.0;     // rate of request arrivals in high traffic period //converted to minutes
const double LOW_RATE = 1/600.0;     // rate of request arrivals in low traffic period //converted to minutes
const double SERVICE_RATE = 1/2.0;     // rate of servicing requests //converted to minutes
const double LOWTOHIGH_RATE = 1/960.0;     // rate of transition into high traffic statee //converted to minutes
const double HIGHTOLOW_RATE = 1/480.0;     // rate of transition into low traffic state //converted to minutes

rewards 
	avail=0 : UNAVAILABLE_COST; // cost for system unavailability
	status=1 & avail=1 : DEGRADED_COST; // cost for availability with degraded performance
endrewards

module secondRejuvenation

fdelay maintenanceInterval= 20160.0;  		//converted to minutes
fdelay repairOrrejuvenationTime= 10.0;        ////


	status: [0..2] init 0; // 0-OK, 1-degraded, 2-failed
	avail: [0..1] init 1; // 0-unavailable, 1-available
	maintenance: [0..2] init 0; // 0-no rejuvenation, 1-rejuvenation on standby, 2-rejuvenation ongoing
	traffic: [0..1] init 0; // 0-high traffic, 1-low traffic
	bufferUsage: [0..BUFFER_SPACES] init 0; // amount of buffers that are in use. Those that are not in use are free


	[degrade] (status=0) & (avail=1) -> DEGRADATION_RATE: (status'=1);    					

	[fail] (status=1) & (avail=1) -> FAILURE_RATE: (status'=2) & (avail'=0) & (maintenance'=0) & (bufferUsage'=0); 

	[repair] (status=2) --repairOrrejuvenationTime-> (status'=0) & (avail'=1); 			

	[tclock] (maintenance=0) & (avail=1) --maintenanceInterval-> (maintenance'=1);

	[rejuvenate] (maintenance=2) --repairOrrejuvenationTime-> (maintenance'=0) & (avail'=1) & (status'=0);

	[highToLowTransitionWithoutRej] (traffic=0) & ((maintenance!=1) | (bufferUsage!=0)) -> HIGHTOLOW_RATE: (traffic'=1);

	[highToLowTransitionWithRej] (traffic=0)&(bufferUsage=0)&(maintenance=1) -> HIGHTOLOW_RATE: (traffic'=1)&(maintenance'=2)&(bufferUsage'=0)&(avail'=0);

	[lowToHighTransition] (traffic=1) -> LOWTOHIGH_RATE: (traffic'=0);

	[genRequestLow] (bufferUsage<BUFFER_SPACES) & (traffic=1) & (avail=1) -> LOW_RATE: (bufferUsage'=bufferUsage +1);

	[genRequestHigh] (bufferUsage<BUFFER_SPACES) & (traffic=0) & (avail=1) -> HIGH_RATE: (bufferUsage'=bufferUsage +1);

	[serveRequests] (bufferUsage>1) -> SERVICE_RATE: (bufferUsage'=bufferUsage -1);

	[serveLastRequestWithoutRej] (bufferUsage=1) & ((maintenance!=1) | (traffic!=1)) -> SERVICE_RATE: (bufferUsage'=0);

	[serveLastRequestWithRej] (bufferUsage=1)&(maintenance=1)&(traffic=1) -> SERVICE_RATE: (bufferUsage'=0)&(maintenance'=2);


endmodule

