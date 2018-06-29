fdctmc

// transition costs
const double TIMEOUT_COST=1.0;

// rates
const double GENERATION_RATE = 1;  // rate of generating messages
const double MEDIUM_ACCESS_RATE = 0.5; // rate of accessing the transmission medium

rewards //costs for timeouts
	[timeout] true : TIMEOUT_COST; 
endrewards

module transmissionLine

fdelay timeoutTime= 5.0;  		// time it takes to cancel transmission (timeout)
fdelay transmissionTime= 1.0;        // time it takes to do the transmission after acquiring the medium


	transmitionStatus: [0..2] init 0; // 0-not transmitting, 1- began, no medium access yet, 2- got media access and transmitting
	//DSPN related commentary: 0-P0,1-P2,2-P3. P1 has a token when 1 or 2.


	[generateMessage] (transmitionStatus=0) -> GENERATION_RATE: (transmitionStatus'=1);    					

	[timeout] (transmitionStatus>0) --timeoutTime-> (transmitionStatus'=0); 

	[accessMedium] (transmitionStatus=1) -> MEDIUM_ACCESS_RATE: (transmitionStatus'=2); 	

	[transmission] (transmitionStatus=2) --transmissionTime-> (transmitionStatus'=0);		

endmodule

