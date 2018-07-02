gsmp

// rates
const double PREEMPTION_RATE = 0.5; // rate at the system enters a pre-emption state discontinuing the service
const double CONTINUATION_RATE = 2.0; // rate at the system goes back into a state that allows service

module twoPhaseService

event service1Time  = dirac(1.5); // time it takes to finish the first part of the job
event service2Time  = dirac(0.5); // time it takes to finish the second part of the job
		
	preemption : [0..1] init 0; // 0- continuing service, 1- not continuing service
	stage : [0..1] init 0; // 0- doing the first part of the job, 1- doing the second part of the job

	[discontinue] (preemption=0) -> PREEMPTION_RATE: (preemption'=1);

	[continue] (preemption=1) -> CONTINUATION_RATE: (preemption'=0);

	[firstStage] (stage=0) & (preemption=0) --service1Time-> (stage'=1);

	[secondStage] (stage=1) & (preemption=0) --service2Time-> (stage'=0);

endmodule
