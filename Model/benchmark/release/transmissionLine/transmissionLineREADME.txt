COMMENTARY:
Contains concurrent fixed delay transitions.
t0 is intended to have arbitrary distribution with average firing time 1, but exponential distribution with rate 1 is used.
Model is regenerative.

MODIFIABLE PARAMETERS: None

DSPN EXPLANATION:
t0 represents message generation.
It puts tokens in P1 and P2.
Then medium must be acquired through t2, and transmission itself is t3.
If t2 and t3 are too slow to fire, t1 fires before them, representing a timeout and cancelling the whole process.
After either successful transmission or a timeout we return to initial marking state.

MODEL OPTIMAL VALUE PROBLEM:
None that I noticed.


DATE AND AUTHOR:

9 February 2017 
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: A characterization of the stochastic process underlying a stochastic Petri net
Authors: Gianfranco Ciardo, Member, IEEE, Reinhard German, Christoph Lindemann, Member, IEEE,
http://ieeexplore.ieee.org/abstract/document/297939/