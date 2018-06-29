COMMENTARY:
Modelled on relatively simple SPN with only one guarded instant transition.
The original SPN seemed to be flawed, so it was first remodelled to a more realistic SPN.
The new one only allows "reset" to happen WHILE firing the "Trej" transition.
There are ORIS models of both the original one and the remade SPNs.

MODIFIABLE PARAMETERS: None

DSPN EXPLANATION:
System is initially "up" and "available" but gets degraded at an exponential rate.
After degradation it can then fail completely, making a repair necessary.
However, there is also a rejuvenation subsystem in place to try to avoid failures from happening.
When the system is available, there is a very long fixed delay running to start the rejuvenation.
When "Tclock" finally fires rejuvenation begins, which makes the system unavailable for a short moment
but allows the system to return to "up" state in case it is degraded.

MODEL OPTIMAL VALUE PROBLEM:
"Tclock" deterministic delay.

With too frequent rejuvenations we are less likely to see total failures or degraded performance
but we will spend more time being unavailable due to rejuvenation itself.
If the rejuvenations are too infrequent, the system is more likely to operate with degraded performance
or not operate at all due to total failure.


DATE AND AUTHOR:

11 November 2016 
Mario Uhrik

ORIGINAL SPN SOURCE: 

Book: Performance Analysis of Communication Systems : Modeling with Non-Markovian Stochastic Petri Nets
ISBN: 978-0-471-49258-0
Author: Reinhard German
Page 372, Figure 17.9