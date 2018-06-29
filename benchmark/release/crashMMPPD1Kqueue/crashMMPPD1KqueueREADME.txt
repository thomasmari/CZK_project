COMMENTARY:
Compared to the availMMPPD1Kqueue model, the way failures affect the server 
has been changed heavily. This one seems more realistic.

MODIFIABLE PARAMETERS: K=5, N=4

DSPN EXPLANATION:
Single-server queueing system with markov modulated poisson process arrivals and deterministic service.
System can crash through exponential transition and be fixed through fixed delay - in a loop.
While crashed, system ejects all enqueued arrivals, and rejects all new arrivals until repaired.

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