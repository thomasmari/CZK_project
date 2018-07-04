ctmc

// costs in states
const double RESENDING_COST=1.0;


// rates
const int k;
const double timeout = 0.001; 
const double FWD_C2E = 1/10;
const double FWD_E2C = 50;
const double BWD_C2E = 1/5;
const double BWD_E2C = 30;
const double TIMEOUT = 0.001;
rewards 
	transmissionResult=1 : RESENDING_COST; // cost for having to spend time resending packets
endrewards

module stopAndWait

//event ttx= dirac(0.001);   //time for transmission+ack+propagation of a packet through a channel and back through another // TODO: FIND OUT THE REAL RATE
//event tretx= dirac(0.001); //same, but for retrying to send failed packets // TODO: FIND OUT THE REAL RATE
		
	transmissionResult : [0..1] init 0; // 0-last transmission attempt succeeded, 1-last transmission attempt failed
	fwd : [0..1] init 0; //0-Forward Correct, 1-Forward Erroneous // represents correct/erroneous transmission of a packet through the forward channel
	bwd : [0..1] init 0; //0-Backward Correct, 1-Backward Erroneous // represents getting acknowledgement/timeout through the backward channel
	// fwd and bwd are changing between purely error-free periods (=0) and error burst periods (=1)
	// They are two independent channels, hence they each have their own state
	
	[send] (transmissionResult=0) & (fwd=0) & (bwd=0) -> (transmissionResult'=transmissionResult); // nothing changes 

	[send] (transmissionResult=0) &  ((fwd=1) | (bwd=1)) -> (transmissionResult'=1);

	[send] (transmissionResult=1) & (fwd=0) & (bwd=0) -> (transmissionResult'=0);

	[send] (transmissionResult=1) &  ((fwd=1) | (bwd=1)) -> (transmissionResult'=transmissionResult); //nothing changes 


	[fwdBeginErrorBurst] (fwd=0) -> FWD_C2E: (fwd'=1);    	

	[fwdEndErrorBurst] (fwd=1) -> FWD_E2C: (fwd'=0); 

	[bwdBeginErrorBurst] (bwd=0) -> BWD_C2E: (bwd'=1);    	

	[bwdEndErrorBurst] (bwd=1) -> BWD_E2C: (bwd'=0); 


endmodule

module trigger
i : [1..k+1];

[] i < k -> k/timeout : (i'=i+1);
[send] i = k -> k/timeout : (i'=1);

endmodule




