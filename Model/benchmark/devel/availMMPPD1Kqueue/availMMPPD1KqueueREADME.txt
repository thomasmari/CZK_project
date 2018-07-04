COMMENTARY:
Note that the even after failure, the system can still enqueue new arrivals.
For more realistic failures, check the crashMMPPD1Kqueue model.

MODIFIABLE PARAMETERS: K=5, N=4

DSPN EXPLANATION:
Single-server queueing system with markov modulated poisson process arrivals and deterministic service.
Service can only happen if the system is available.
System becomes unavailable through exponential transition and fixed through fixed delay - in a loop.

MODEL OPTIMAL VALUE PROBLEM:
None.


DATE AND AUTHOR:

31 January 2017
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: Transient analysis of deterministic and stochastic Petri nets with concurrent deterministic transitions
in Peformance Evaluation 36-37 (1999)
Author: Christoph Lindemann, Axel Thümmler
Pages 35-54 
http://www.sciencedirect.com/science/article/pii/S0166531699000206