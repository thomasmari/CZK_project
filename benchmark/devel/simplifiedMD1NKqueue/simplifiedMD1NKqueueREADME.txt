COMMENTARY:
Extremely simple model.
This "simplified" version did not reproduce P4 from the DSPN.
Mostly because I consider it unnecessary, and to demonstrate fdCTMC has a better way of 
making sure only one customer is served at a time.
asIsMD1NKqueue model reproduces P4.

The purpose of this model is to demonstrate how extremely easily can fdCTMC be modified
even though we change the DSPN significantly.

MODIFIABLE PARAMETERS: K=5, N=2

DSPN EXPLANATION:
Single-server queueing system with memoryless input from a finite pool of size K and capacity of N (M/D/1/N/K).
(This one enqueues "customers")

MODEL OPTIMAL VALUE PROBLEM:
None.

DATE AND AUTHOR:

7 February 2017
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