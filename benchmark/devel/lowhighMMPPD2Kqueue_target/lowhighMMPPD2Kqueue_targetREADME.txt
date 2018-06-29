COMMENTARY:
This version of the model has a target state - the empty queue.
Modifiable parameter K=5 is expected to be at least 5.
The model starts with high burstiness, both service stations occuppied,
and one more request in the queue waiting.
Cost is placed on rejected arrivals.
Hence, the higher K is, the less likely is it for the queue to fill up
and cause costs.

Contains concurrent deterministic transitions.

MODIFIABLE PARAMETERS: K=5

DSPN EXPLANATION:
Two-server queueing system with markov modulated poisson process arrivals and deterministic service.
This version uses only 2-state burstiness - low traffic and high traffic periods.

MODEL OPTIMAL VALUE PROBLEM:
None.


DATE AND AUTHOR:

24 May 2017
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: Transient analysis of deterministic and stochastic Petri nets with concurrent deterministic transitions
in Peformance Evaluation 36-37 (1999)
Author: Christoph Lindemann, Axel Thümmler
Pages 35-54 
http://www.sciencedirect.com/science/article/pii/S0166531699000206