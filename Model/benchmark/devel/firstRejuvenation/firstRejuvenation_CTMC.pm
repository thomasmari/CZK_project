ctmc

const int k;
// cost in states
const double UNAVAILABLE_COST=20.0;
const double DEGRADED_COST=0.5;

const double repairTime= 360.0;             ////
const double maintenanceTime= 20160.0;  //converted to minutes
const double rejuvenationTime= 10.0;        ////

// rates
const double DEGRADATION_RATE = 1/14400;  //converted to minutes
const double FAILURE_RATE = 1/129600;     //converted to minutes

rewards 
	avail=0 : UNAVAILABLE_COST; // cost for system unavailability
	status=1 & avail=1 : DEGRADED_COST; // cost for availability with degraded performance

endrewards

module firstRejuvenation




	status: [0..2] init 0; // 0-OK, 1-degraded, 2-failed
	avail: [0..1] init 1; // 0-unavailable, 1-available
	maintenance: [0..1] init 0; // 0-waiting for rejuvenation, 1-rejuvenation
	

	[degrade] (status=0) & (avail=1) -> DEGRADATION_RATE: (status'=1);    					

	[fail] (status=1) & (avail=1) -> FAILURE_RATE: (status'=2) & (avail'=0); 

	[repair] (status=2) -> (status'=0) & (avail'=1); 			

	[tclock] (maintenance=0) & (avail=1) -> (maintenance'=1) & (avail'=0);

	[rejuvenate] (maintenance=1) -> (maintenance'=0) & (avail'=1) & (status'=0);


endmodule

module trigger_r
i_r: [1..k+1];

[] i_r< k -> k/repairTime : (i_r'=i_r+1);
[repair] (i_r= k)|((status=2)) -> k/repairTime : (i_r'=1);

endmodule

module trigger_m
i_m: [1..k+1];

[] i_m< k -> k/maintenanceTime : (i_m'=i_m+1);
[tclock] (i_m= k) | !((maintenance=0) & (avail=1))  -> k/maintenanceTime : (i_m'=1);

endmodule

module trigger_rej
i_rej: [1..k+1];

[] i_rej< k -> k/rejuvenationTime : (i_rej'=i_rej+1);
[rejuvenate] i_rej= k | (maintenance=0) -> k/rejuvenationTime : (i_rej'=1);

endmodule
