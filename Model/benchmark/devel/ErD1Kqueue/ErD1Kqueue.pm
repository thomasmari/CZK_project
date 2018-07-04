fdctmc

// model specific constants
const int BUFFERS  = 50;   //amount of buffers (K)
const int PHASES    = 5;   //amount of phases (r)
const double LAMBDA = 9.0; // basic rate

// rates
const double ARRIVAL_RATE = PHASES * LAMBDA;  //calculated rate of arrivals

module ErD1Kqueue

fdelay service = 0.1;  		//service time


	bufferUsage: [0..BUFFERS] init 0; // number of buffers currently used for servicing requests.
	phasesDone: [0..(PHASES-1)] init 0; // number of phases already done
	serverAvail: [0..1] init 1; // 1 only if the system awaits more requests

	[firstPhase] (serverAvail=1) & (phasesDone=0) & (bufferUsage!=BUFFERS) -> ARRIVAL_RATE: (serverAvail'=0) & (phasesDone'=1); 	

	[nextPhase]  (serverAvail=0) & (phasesDone<(PHASES-1)) & (bufferUsage!=BUFFERS) -> ARRIVAL_RATE: (phasesDone'=phasesDone + 1);    					

	[enqueue] (phasesDone=(PHASES-1)) & (bufferUsage!=BUFFERS) -> ARRIVAL_RATE: (phasesDone'=0) & (bufferUsage'=bufferUsage + 1) & (serverAvail'=1);

	[service] (bufferUsage>0) --service-> (bufferUsage'=bufferUsage - 1); 		

endmodule

