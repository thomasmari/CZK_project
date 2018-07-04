COMMENTARY:
Alternative (improved) model to basic secondRejuvenation which 
also models generation of requests while all buffers are busy.
In that case the requests are immediately discarded, but now they are trackable.
Costs are therefore set for all discarded requests and nothing else.

MODIFIABLE PARAMETERS: 	BUFFER_SPACES=10

DSPN EXPLANATION:
System is initially "up" and "available" but gets degraded at an exponential rate.
After degradation it can then fail completely, making a repair necessary.
Service requests arrive at an exponential rate and are stored into a buffer.
Then they are immediately served at an exponential rate if the whole system is available,
or discarded if the system is not available.
There are also places "high" and "low" which model request traffic amount periods.
However, there is also a rejuvenation subsystem in place to try to avoid failures from happening.
When the system is available, there is a very long fixed delay running to start the rejuvenation.
When "Tclock" finally fires and there are no pending service requests and currently there is a low request traffic
rejuvenation begins, which makes the system unavailable for a short moment
but allows the system to return to "up" state in case it is degraded.

MODEL OPTIMAL VALUE PROBLEM:
"Tclock" deterministic delay.

With too frequent rejuvenations we are less likely to see total failures or degraded performance
but we will spend more time being unavailable due to rejuvenation itself.
If the rejuvenations are too infrequent, the system is more likely to have degraded performance or fail
completely.
The difference compared to the first model is that now we can observe it on the loss/service of requests.
Also the difference compared to the basic version of this model is that we can generate requests while the buffer is full.


DATE AND AUTHOR:

13 December 2016 
Mario Uhrik

ORIGINAL SPN SOURCE: 

Book: Performance Analysis of Communication Systems : Modeling with Non-Markovian Stochastic Petri Nets
ISBN: 978-0-471-49258-0
Author: Reinhard German
Page 374, Figure 17.11