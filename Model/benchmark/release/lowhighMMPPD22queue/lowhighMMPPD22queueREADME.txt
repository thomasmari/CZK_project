COMMENTARY:
This one is optimised for K=2, but only supports K=2.
lowhighMMPPD2Kqueue.pm fdprism model is redundant for K=2, but also supports K>2.
They both contain concurrent deterministic transitions.
The burstiness was changed - the original did not make much sense to me.

MODIFIABLE PARAMETERS: None

DSPN EXPLANATION:
Two-server queueing system with markov modulated poisson process arrivals and deterministic service.
This version uses only 2-state burstiness - low traffic and high traffic periods.

MODEL OPTIMAL VALUE PROBLEM:
None.


DATE AND AUTHOR:

28 January 2017
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: Transient analysis of deterministic and stochastic Petri nets with concurrent deterministic transitions
in Peformance Evaluation 36-37 (1999)
Author: Christoph Lindemann, Axel Thümmler
Pages 35-54 
http://www.sciencedirect.com/science/article/pii/S0166531699000206