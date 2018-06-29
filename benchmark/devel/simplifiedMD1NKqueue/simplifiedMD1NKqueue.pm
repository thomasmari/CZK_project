fdctmc

//model specific constant
const int K = 5; // number of customers who exist
const int N = 2; // queue capacity

// rates
const double THINKING_RATE = 0.9;

module simplifiedMD1NKqueue

fdelay service = 1.0;  	

	thinkingCustomers: [(K-N)..K] init K; // number of customers who are still thinking about making a service request.

	[thinking] (thinkingCustomers>(K-N)) -> (THINKING_RATE * thinkingCustomers): (thinkingCustomers'=thinkingCustomers-1);

	[serving] (thinkingCustomers<K) --service-> (thinkingCustomers'=thinkingCustomers+1);

endmodule

