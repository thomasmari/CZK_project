COMMENTARY:
The model is very obviously regenerative.

MODIFIABLE PARAMETERS: K=2

DSPN EXPLANATION:
Models a simple transmission protocol.
Initially the model has capacity K=2.
Requests are generated through Generate and stored in Wait.
Then the service is initiated through Initiate if there is a token in Ready.
The model is now Busy.
Timeout fixed delay has started.
During transmission, there may be Noise, which restarts the Timeout.
When the transmission completes, it might have been OK or there may have been an Error.
If there was an Error, we need to wait until the timeout.
If it was OK, the receiver sends an Ack signal and the transmission is fully complete.
We return to the initial marking.

MODEL OPTIMAL VALUE PROBLEM:
Timeout fixed delay.

If the Timeouts are too small, we may cancel the transmissions before they have a chance to finish.
If the Timeouts are too lengthy, incase of erroneous transmissions we wait redundantly.

There should therefore exist an ideal Timeout fixed delay for which we can maximise successful transmissions.


DATE AND AUTHOR:

13 February 2017
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: Analysis of Deterministic and Stochastic Petri Nets
Authors:	Gianfranco Ciardo
	 	Christoph Lindemann
http://ieeexplore.ieee.org/abstract/document/393454/