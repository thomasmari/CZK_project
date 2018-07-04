fdctmc

// transition rewards
const double SUCCESS_REWARD = 1.0;

// model specific constants
const int K = 2; // maximum queue size (amount of requests awaiting service)
const double ERROR_P = 0.01; // probability of an erroneous transmission
const double OK_P = 0.99; // probability of an OK transmission

// rates
const double GEN_RATE = 1/60.0; // rate at which requests arrive if the queue is not full
const double TRANSMIT_M_RATE = 1/5.0; // rate at which we transmit the message
const double NOISE_RATE  = 1/300.0; // rate at which the transmission has to restart due to noise in the channel
const double TRANSMIT_ACK_RATE = 1/1.0; // rate at which the receiver transmits ack signal

rewards 
	[transmitAckLast] true : SUCCESS_REWARD; // reward for a successful transmission
	[transmitAckAndInitiate] true : SUCCESS_REWARD; // reward for a successful transmission
endrewards

module simpleTransmissionProtocol

fdelay timeoutTime = 30.0; // time until Timeout of a transmission attempt
		
	requests: [0..K] init 0; // amount of requests that have arrived and are awaiting service
	transmissionStatus: [0..3] init 0; // 0-not doing anything (Ready=1), 1- transmitting (DSPN Message=1) , 2-success (DSPN PositiveAck=1), 3-error (DSPN DoNothing=1)
						//also transmissionStatus>0 means DSPN Busy=1

	[generate] (requests<K) & (transmissionStatus>0) -> GEN_RATE: (requests'=requests+1);

	[generateAndInitiate] (requests<K) & (transmissionStatus=0) -> GEN_RATE: (requests'=requests+1) & (transmissionStatus'=1);

	[timeout] (transmissionStatus>0) --timeoutTime-> (transmissionStatus'=1);

	[transmitMOK] (transmissionStatus=1) -> (TRANSMIT_M_RATE * OK_P): (transmissionStatus'=2);

	[transmitMError] (transmissionStatus=1) -> (TRANSMIT_M_RATE * ERROR_P): (transmissionStatus'=3);

	//[noiseRestart] (transmissionStatus=1) -> NOISE_RATE: true;  // originally intended to restart timeout, but ditched

	[transmitAckLast] (transmissionStatus=2) & (requests=1) -> TRANSMIT_ACK_RATE: (requests'=requests-1) & (transmissionStatus'=0);

	[transmitAckAndInitiate] (transmissionStatus=2) & (requests>1) -> TRANSMIT_ACK_RATE: (requests'=requests-1) & (transmissionStatus'=1);

endmodule
