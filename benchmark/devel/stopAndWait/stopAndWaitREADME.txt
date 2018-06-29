COMMENTARY:
Simple to understand. 
Contains quite a long sequence of immediate transitions.

MODIFIABLE PARAMETERS: None

DSPN EXPLANATION:
Models the continuous transmission of frames (including receiving ACK)
through independent forward and backward channels.
Two lower subnets model forward channel and backward channel "correct" and "error burst" periods.
(refers to the observation that errors dont happen "out of the blue" but in bursts)
The upper subnet just sends the frames through "Ptx" normally or "PretX" if the previous transmission failed.
Transmission succeeds if at the time of "Ttx"/"TretX" firing both channels are in "correct" states.

MODEL OPTIMAL VALUE PROBLEM:
None (that I noticed).

DATE AND AUTHOR:

8 November 2016 
Mario Uhrik

ORIGINAL SPN SOURCE: 

Book: Performance Analysis of Communication Systems : Modeling with Non-Markovian Stochastic Petri Nets
ISBN: 978-0-471-49258-0
Author: Reinhard German
Page 349, Figure 16.3