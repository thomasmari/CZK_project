COMMENTARY:
Contains exponential transitions with rates dependent on marking.

MODIFIABLE PARAMETERS: M=10

DSPN EXPLANATION:
M=10 is the amount of modules.
In the beginning they are all Operable in P1.
While in P1, they may fail at anytime through T9 and become Failing/Unknown, going to P5.
When detection period begins through T10, concurrent weighted immediate transitions
decide what happens next with the modules.
Operable modules might either continue being operable, or need a repair going to P4.
Modules in P4 are repaired through T8 and during the repair they are not used.
Failing/Unknown might either need a repair after the next detection period,
or be reused (postpone the repair) if lucky.
In the end of the detection period, these decisions are carried out.
Then next nonDetection period begins, during which nothing happens.
These detection/nonDetection periods loop forever and prompt changes in the nonDetection period
marking of P1/P4/P5.

MODEL OPTIMAL VALUE PROBLEM:
???


DATE AND AUTHOR:

4 February 2017
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: Analysis of self-stabilizing clock synchronization by means of stochastic Petri nets
Author: MEILIU Lu, DU ZHANG, TADAO MUMTA
http://ieeexplore.ieee.org/document/53573/