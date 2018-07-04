COMMENTARY:
Relatively complex model that took me many hours to work on.
Contains rates dependent on the marking.

MODIFIABLE PARAMETERS: NUM_CPUS=4

DSPN EXPLANATION:
Models a multiprocessor system where p1 initial marking is the amount of processors in the system.
In the fdCTMC, the amount of processors can be easily changed through the model specific constant.
Processors then generate memory access requests which they may serve only one at a time because of a shared bus.
At any time they may fail, after which the system needs to reconfigure (using up the bus).
After this reconfiguration, the remaining processors may operate and the failed one is being repaired at an exponential rate.
After it is repaired, another reconfiguration is needed before returning to normal.

MODEL OPTIMAL VALUE PROBLEM:
initial marking of p1 - amount of processors

With more processors we can generate more requests and utilise the bus better (which acts as a bottleneck).
However, using more processors also increases the rate of failure occurence.


DATE AND AUTHOR:

19 December 2016
Mario Uhrik

ORIGINAL SPN SOURCE: 

On Petri nets with deterministic and exponentially
distributed firing times 
Authors:	Marco Ajmone Marsan	
		Giovanni Chiola	
Published in:
Proceeding
Advances in Petri Nets 1987, covers the 7th European Workshop on Applications and Theory of Petri Nets
Pages 132-145 
Springer-Verlag London, UK ©1987 
table of contents ISBN:3-540-18086-9
https://link.springer.com/chapter/10.1007/3-540-18086-9_23