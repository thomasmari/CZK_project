COMMENTARY:
Has exponential transitions with rates dependent on markings.
There are no concurrent fixed delay transitions, because repairs and service are exclusive.

Note that the system starts in failed mode, which is unusual.

MODIFIABLE PARAMETERS: K=10, N=3

DSPN EXPLANATION:
Queueing system with deterministic service and finite buffer.
Arrival process is a "superposition of several identical 2-state MMPPs".
In addition, there are failures that can occur at any time through an exponential transition.
In that case, the system needs to be repaired through a fixed delay transition.

MODEL OPTIMAL VALUE PROBLEM:
None that I noticed.


DATE AND AUTHOR:

12 February 2017
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: A fourth-order algorithm with automatic stepsize control for the transient analysis of DSPNs
Authors:  Armin Heindl, Reinhard German
http://ieeexplore.ieee.org/abstract/document/761445/