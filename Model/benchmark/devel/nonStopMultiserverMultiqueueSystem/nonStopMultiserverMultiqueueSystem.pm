fdctmc

// model specific constants
const int K1 = 4; // amount of queue slots in the first queue
const int K2 = 4; // amount of queue slots in the second queue

// transition costs
const double REJECT_COST=1.0; // cost for rejecting an arrival (queue full)

// rates
const double ARRIVAL1_RATE = 0.5; // rate at which a customers enter the first queue
const double ARRIVAL2_RATE = 0.5; // rate at which a customers enter the second queue
const double WALKING1_RATE = 1.0; // rate at which the first server "walks" to the second
const double WALKING2_RATE = 1.0; // rate at which the second server "walks" to the first

rewards //costs for rejecting arrivals
	[reject1]    true : REJECT_COST; 
	[reject2]    true : REJECT_COST; 
	[rejectBoth] true : REJECT_COST;
endrewards

module nonStopMultiserverMultiqueueSystem

fdelay service11Time  = 1.0; // time it takes to serve a request by server 1 in queue 1
fdelay service21Time  = 1.0; // time it takes to serve a request by server 2 in queue 1
fdelay service12Time  = 1.0; //time it takes to server a request by server 1 in queue 2
fdelay service22Time  = 1.0; // time it takes to serve a request by server 2 in queue 2
		
	q1Size : [0..K1] init 0; // amount of customers in the first queue
	q2Size : [0..K2] init 0; // // amount of customers in the second queue
	s11Busy: [0..1] init 0; // 0-ready, 1-busy (server 1,1)
	s12Busy: [0..1] init 0; // 0-ready, 1-busy (server 1,2)
	s21Busy: [0..1] init 0; // 0-ready, 1-busy (server 2,1)
	s22Busy: [0..1] init 0; // 0-ready, 1-busy (server 2,2)
	q1Walk: [0..2] init 2; // amount of services that were done for the first queue
	q2Walk: [0..2] init 0; // amount of services that were done for the second queue

//arrivals
	//queue 1 arrival
	[generate1] (q1Size<K1) -> (ARRIVAL1_RATE): (q1Size'=q1Size+1); 

	[reject1] (q1Size=K1) & (q2Size!=K2) -> (ARRIVAL1_RATE): true;
	//queue 2 arrival 
	[generate2] (q2Size<K2) -> (ARRIVAL2_RATE): (q2Size'=q2Size+1); 

	[reject2] (q2Size=K2) & (q1Size!=K1) -> (ARRIVAL2_RATE): true;

	[rejectBoth] (q2Size=K2) & (q1Size=K1) -> (ARRIVAL2_RATE + ARRIVAL1_RATE): true; // looks useless, but otherwise fdPRISM would not build it.
//service q1
	[serve11] (s11Busy=1) --service11Time-> (s11Busy'=0) & (q1Walk'=q1Walk+1) & (q1Size'=q1Size-1);

	[serve21] (s21Busy=1) --service21Time-> (s21Busy'=0) & (q1Walk'=q1Walk+1) & (q1Size'=q1Size-1);
//service q2
	[serve12] (s12Busy=1) --service12Time-> (s12Busy'=0) & (q2Walk'=q2Walk+1) & (q2Size'=q2Size-1);

	[serve22] (s22Busy=1) --service22Time-> (s22Busy'=0) & (q2Walk'=q2Walk+1) & (q2Size'=q2Size-1);
//walking from 1 to 2
	[walk1AvailBoth12] (q1Walk>0) & (q2Size>0) & (s22Busy=0) & (s12Busy=0) -> (WALKING1_RATE * 0.5): (q1Walk'=q1Walk-1) & (s12Busy'=1); // walk from q1 to q2 avail (if q2 at least 2)
	//decide whether to serve 12 or 22
	[walk1AvailBoth22] (q1Walk>0) & (q2Size>0) & (s22Busy=0) & (s12Busy=0) -> (WALKING1_RATE * 0.5): (q1Walk'=q1Walk-1) & (s22Busy'=1); // walk from q1 to q2 avail (if q2 at least 2)

	[walk1Avail12] (q1Walk>0) & (q2Size>1) & (s12Busy=0) & (s22Busy=1) -> WALKING1_RATE: (q1Walk'=q1Walk-1) & (s12Busy'=1); // walk from q1 to q2 avail (if q2 has 1) and serve 12

	[walk1Avail22] (q1Walk>0) & (q2Size>1) & (s22Busy=0) & (s12Busy=1) -> WALKING1_RATE: (q1Walk'=q1Walk-1) & (s22Busy'=1); // walk from q1 to q2 avail (if q2 has 1) and serve 22

	[walk1Walk] (q1Walk>0) & (q2Size=0) -> WALKING1_RATE: (q2Walk'=q2Walk+1) & (q1Walk'=q1Walk-1); // walk from q1 to q2 walk (if q2 empty)
//walking from 2 to 1 - same, just reversed
	[walk2AvailBoth11] (q2Walk>0) & (q1Size>0) & (s11Busy=0) & (s21Busy=0) -> (WALKING2_RATE * 0.5): (q2Walk'=q2Walk-1) & (s11Busy'=1);

	[walk2AvailBoth21] (q2Walk>0) & (q1Size>0) & (s11Busy=0) & (s21Busy=0) -> (WALKING2_RATE * 0.5): (q2Walk'=q2Walk-1) & (s21Busy'=1);

	[walk2Avail11] (q2Walk>0) & (q1Size>1) & (s11Busy=0) & (s21Busy=1) -> (WALKING2_RATE * 0.5): (q2Walk'=q2Walk-1) & (s11Busy'=1);

	[walk2Avail21] (q2Walk>0) & (q1Size>1) & (s21Busy=0) & (s11Busy=1) -> (WALKING2_RATE * 0.5): (q2Walk'=q2Walk-1) & (s21Busy'=1);

	[walk2Walk] (q2Walk>0) & (q1Size=0) -> WALKING2_RATE: (q1Walk'=q1Walk+1) & (q2Walk'=q2Walk-1);


endmodule
