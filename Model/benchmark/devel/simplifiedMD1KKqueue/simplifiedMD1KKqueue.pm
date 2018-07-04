fdctmc

//model specific constant
const int K = 2; // number of customers who exist

// rates
const double THINKING_RATE = 0.9;

module simplifiedMD1KKqueue

fdelay service = 1.0;  	

	thinkingCustomers: [0..K] init K; // number of customers who are still thinking about making a service request.

	[thinking] (thinkingCustomers>0) -> (THINKING_RATE * thinkingCustomers): (thinkingCustomers'=thinkingCustomers-1);

	[serving] (thinkingCustomers<K) --service-> (thinkingCustomers'=thinkingCustomers+1);

endmodule

