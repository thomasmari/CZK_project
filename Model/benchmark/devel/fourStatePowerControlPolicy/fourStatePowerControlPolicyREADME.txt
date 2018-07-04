COMMENTARY:
More complex version of the twoStatePowerControlPolicy.

This model is heavily focused on costs.
Contains both transition and state costs.

The arrival rate is made up by me - more information in the Oris DSPN model comment.

Despite how many fixed delay transitions there are, there seems to be no concurrency.
At least after my slight modification, which seems to be the way the model was originally intended by original authors.
I added the inhibitor arc from "active" to "activate".

Also, the "request" place in the DSPN seems to be absolutely pointless.
However, the interesting thing about fdPRISM implementations is that by nature
I can omit it anyway, because it never changes.

MODIFIABLE PARAMETERS: CAPACITY=8

DSPN EXPLANATION:
Models DRAM power usage.
Memory access requests are generated through "arrival".
We can only generate at most 8 at a time.
After the model receives requests, it needs to "activate" them, and then "service" every request in the queue.
Afterwards it goes back to idle.
If it is idle for some time, it can go on standby (lower power usage state).
After some time on standby without requests, it can go asleep (even lower power usage state).
After yet more time without requests, it can go from asleep into powerdown state.
Powerdown state is uses almost no power, but takes relatively long to wake up from.
Any of these power saving states can be interrupted by an incoming request.

MODEL OPTIMAL VALUE PROBLEM:
"standby", "sleep", "powerdown" fixed delay transitions

If the model goes into power saving states too early, we will waste power and time on resync.
If the model goes into power saving states too late, we will waste powe by remaining in active state needlessly.


DATE AND AUTHOR:

17 February 2017
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: Modeling of DRAM Power Control Policies Using Deterministic and Stochastic Petri Nets
Authors: Xiaobo Fan, Carla S. Ellis, Alvin R. Lebeck
http://link.springer.com/chapter/10.1007/3-540-36612-1_9