fdctmc

// model specific constants
const int K_CONSTANT = 5; //K is the amount of buffers
const int A_CONSTANT = 10; //A is the amount of slots in the transmission period
const int B_CONSTANT = 5; //B is the amount of slots in the non-transmission period. USED in the definition of fdelay noTransmissionDuration
const double T_CONSTANT = 1.0; //T is the slot duration.   USED in the definition of fdelay slotDuration

// transition costs
const double FLUSH_COST = 1.0;


// rates
const double CELL_GEN_RATE = 0.5; // rate at which cells are generated into buffers

rewards 
	[flush] true : FLUSH_COST; // cost for not having a cell ready when new slot is to be transmitted
endrewards

module slotCounterFrameCellTransmission

fdelay slotDuration= 1.0; // duration of a slot (time spent trying to transmit a cell)
fdelay noTransmissionDuration= 1.0 * 5; //duration of a period of no transmissions
		
	bufferUsage : [0..K_CONSTANT] init 0; // amount of buffers that are currently in use. Those that are not in use are free.
	period : [0..1] init 0; // 0 is the transmission period, 1 is the non-transmission period
	counter : [0..A_CONSTANT] init 0; // counter of how many slots of the current transmission period have occured
	
	[generateCell] (bufferUsage<K_CONSTANT)  -> CELL_GEN_RATE: (bufferUsage'=bufferUsage + 1);

	[flush] (period=0) & (bufferUsage=0) & (counter< A_CONSTANT - 1) --slotDuration-> (counter'=counter + 1);

	[flushLast] (period=0) & (bufferUsage=0) & (counter= A_CONSTANT - 1) --slotDuration-> (counter'= 0) & (period'=1);

	[transmit] (period=0) & (bufferUsage>0) & (counter< A_CONSTANT - 1) --slotDuration-> (counter'=counter + 1) & (bufferUsage'=bufferUsage - 1);

	[transmitLast] (period=0) & (bufferUsage>0) & (counter= A_CONSTANT - 1) --slotDuration-> (counter'= 0) & (bufferUsage'=bufferUsage - 1) & (period'=1);

	[reenterTransmissionPeriod] (period=1) --noTransmissionDuration-> (period'=0);


endmodule

