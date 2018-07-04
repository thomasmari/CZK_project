gsmp

// cost in states
const double UNAVAILABLE_COST=20.0;
const double DEGRADED_COST=0.5;

// rates
const double DEGRADATION_RATE = 1/14400;  //converted to minutes
const double FAILURE_RATE = 1/129600;     //converted to minutes

rewards 
	avail=0 : UNAVAILABLE_COST; // cost for system unavailability
	status=1 & avail=1 : DEGRADED_COST; // cost for availability with degraded performance

endrewards

module firstRejuvenation

fdelay repairTime= 360.0;             ////
fdelay maintenanceInterval= 20160.0;  //converted to minutes
fdelay rejuvenationTime= 10.0;        ////


	status: [0..2] init 0; // 0-OK, 1-degraded, 2-failed
	avail: [0..1] init 1; // 0-unavailable, 1-available
	maintenance: [0..1] init 0; // 0-waiting for rejuvenation, 1-rejuvenation
	

	[degrade] (status=0) & (avail=1) -> DEGRADATION_RATE: (status'=1);    					

	[fail] (status=1) & (avail=1) -> FAILURE_RATE: (status'=2) & (avail'=0); 

	[repair] (status=2) --repairTime-> (status'=0) & (avail'=1); 			

	[tclock] (maintenance=0) & (avail=1) --maintenanceInterval-> (maintenance'=1) & (avail'=0);

	[rejuvenate] (maintenance=1) --rejuvenationTime-> (maintenance'=0) & (avail'=1) & (status'=0);


endmodule

