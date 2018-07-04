COMMENTARY:
fdPRISM implementation has constants B_CONSTANT and T_CONSTANT.
Those constant variables are unused for technical reasons, but they are important and serve as a reminder.
Not too complicated, but can be difficult to understand.

MODIFIABLE PARAMETERS: K=5, A=10

DSPN EXPLANATION:
Models the transmission of a frame through cell slots.
Cells are generated in the upper subnet.
In the lower subnet there is a deterministic transmission "slot" which
is a slot to carry the generated cell.
When "slot" fires, it either transmits the cell through "switch" or there is no cell ready
and the slot is "flush"ed.
Furthermore, counter is incremented towards constant "A" (default 10).
While counter is less than A, "newslot" restarts the whole process.
When counter marking reaches A, a period of no-transmission starts ("notx").
The counter is emptied and meanwhile cells are generated into buffers "buf".
After this no-transmission period ends, we are more likely to see more cells ready for next "slot" firing.
The whole process then starts anew.

MODEL OPTIMAL VALUE PROBLEM:
"notx" deterministic delay FOR EACH PARTICULAR "A" constant (counter limit)
in order to minimise "flush" occurence.
	(Since "notx" delay is defined as ("slot" delay * "B" constant) (B=5 default)
	 it must be an integer)

Note gen is on average half the speed of "slot" delay.
Therefore if the model had no non-transmission periods, many slots would be "flush"ed.
During non-transmission periods the "buf"fers can hold the generated cells
and that way the system can reach the same performance without "flush"ing slots.
With too infrequent or small non-transmission periods, slots will be "flush"ed needlessly.
With too frequent or long non-transmission periods,
we will lose performance ("switch" firing frequency) and have to discard cells due to full "buf"fers.
I.e. we can optimise the non-transmission period so that no performance is lost
and slots are "flush"ed as infrequently as possible.

DATE AND AUTHOR:

22 November 2016 
Mario Uhrik

ORIGINAL SPN SOURCE: 

Book: Performance Analysis of Communication Systems : Modeling with Non-Markovian Stochastic Petri Nets
ISBN: 978-0-471-49258-0
Author: Reinhard German
Page 291, Figure 13.4