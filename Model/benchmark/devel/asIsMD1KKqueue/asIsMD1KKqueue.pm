fdctmc

//model specific constant
const int K = 2; // number of customers who exist

// rates
const double THINKING_RATE = 0.9;

module asIsMD1KKqueue

fdelay service = 1.0;  	

	thinkingCustomers: [0..K] init K; // number of customers who are still thinking about making a service request.
	serving: [0..1] init 0; // 0- currently not serving. 1-currently serving

	[thinking] (thinkingCustomers>0) -> (THINKING_RATE * thinkingCustomers): (thinkingCustomers'=thinkingCustomers-1) & (serving'=1);

	[serving] (thinkingCustomers<K-1)  --service-> (thinkingCustomers'=thinkingCustomers+1);

	[servingLast] (thinkingCustomers=K-1)  --service-> (thinkingCustomers'=thinkingCustomers+1) & (serving'=0);

endmodule

