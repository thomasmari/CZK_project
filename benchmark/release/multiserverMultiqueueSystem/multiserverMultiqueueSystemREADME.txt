COMMENTARY:
Although seemingly simple, it was quite complex to implement.

Has concurrent fixed delay transitions.
Has weighted immediate transitions.

Please note that the starting state was changed to q1Walk instead of q1Avail.
That is because t6 would fire immediately anyway.

MODIFIABLE PARAMETERS: 	K1=4, K2=4

DSPN EXPLANATION:
Mi/D/Mi/Ki/2/L multiserver multiqueue system with exponential walking times.
Comprised of two queues that receive arrivals and of two servers that cyclically attend the queues.

MODEL OPTIMAL VALUE PROBLEM:
None that I noticed.


DATE AND AUTHOR:

14 February 2017
Mario Uhrik

ORIGINAL SPN SOURCE: 

Article: The DSPNexpress 2000 Performance and Dependability Modeling Environment
Authors: Christoph Lindemann, Marco Lohmann, Axel Thümmler, and Oliver Waldhorst
http://ls4-www.cs.tu-dortmund.de/home/thummler/papers/Report723.pdf