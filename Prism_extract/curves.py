import matplotlib.pyplot as plt
from array import array
import sys
import numpy as np

def read_file(filename):
	file = open(filename, "r")
	a = []
	for line in file:
		print line
		a.append(float(line))
	return a


#GLOBAL VARIABLE
Path = '../Log'

#CURVES

def curve_10_random():
	Subpath = '/random/'
	#t=0.1
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('P', fontsize=14, color='black')
	plt.title('Steady State Probability for a queue with phase type fitting parameter k')
	x = range(0,11,1)
	
	y_10 = read_file(Path+Subpath+'queue_10.res')
	y_10_2 = read_file('../Log/random/queueptf_10_2.res')
	y_10_5 = read_file('../Log/random/queueptf_10_2.res')
	y_10_10 = read_file('../Log/random/queueptf_10_2.res')
	y_10_50 = read_file('../Log/random/queueptf_10_2.res')
	y_10_100 = read_file('../Log/random/queueptf_10_2.res')
	y_10_200 = read_file('../Log/random/queueptf_10_2.res')
	
	plt.plot(x, y_10, label = 'k=0',linewidth=7.0)
	#plt.plot(x, y_10_2, label = 'k=2')
	#plt.plot(x, y_10_5, label = 'k=5')
	#plt.plot(x, y_10_10, label = 'k=10')
	#plt.plot(x, y_10_50, label = 'k=50')
	#plt.plot(x, y_10_100, label = 'k=100')
	#plt.plot(x, y_10_200, label = 'k=200')


	plt.legend()
	plt.show()
	
	
	
	
def time_10():
	plt.yscale('log')
	plt.xscale('linear')
	plt.xlabel('k', fontsize=14, color='black')
	plt.ylabel('s', fontsize=14, color='black')
	plt.title('Steady State Probability time computation versus phase type fitting parameter k')
	k = [2,5,10,50,100,200]
	time_Jacobi_Explicit = [0.004,0.007,0.021,1.092,9.951,109.147]
	time_Gauss_Hybrid = [0.002,0.003,0.006,0.011,0.022,0.045]
	time_Power_Hybrid = [0.004,0.005,0.007,0.113,1.018,9.689]

	reftime = [0.062,0.062,0.062,0.062,0.062,0.062]
	plt.plot(k, reftime, label = 'gsmp event model')
	plt.plot(k, time_Jacobi_Explicit, label = 'gsmp Power Explicit')
	plt.plot(k, time_Gauss_Hybrid, label = 'ctmc Gauss Hybrid')
	plt.plot(k, time_Power_Hybrid, label = 'ctmc Power Hybrid')

	plt.legend()
	plt.show()

def size_10():
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('k', fontsize=14, color='black')
	plt.ylabel('size', fontsize=14, color='black')
	plt.title('size of model versus phase type fitting parameter k')
	k = [0,2,5,10,50,100,200]
	states = [11,22,55,110,550,1100,2200]
	transition = [22,41,104,209,1049,2099,4199] 
	plt.plot(k, states, label = 'states')
	plt.plot(k, transition, label = 'transistions')
	plt.legend()
	plt.show()

def curve_6_150_0():
	()


def variance():
	#give the graph of the k according to t for an erlong variance equal to 10^-5
	plt.yscale('log')
	plt.xscale('log')
	plt.xlabel('timeout', fontsize=14, color='black')
	plt.ylabel('k', fontsize=14, color='black')
	plt.title('perfect k versus t')
	epsilon = 10**(-5)
	t0 = range(1,100,1)
	t = []
	k=[]
	for e in t0:
		e_float = float(e)
		r=e_float/100
		print r
		t.append(r)
		k.append((r**2)/epsilon)
	plt.plot(t, k, label = 'k vs. t')
	plt.legend()
	plt.show()

def main():
	()
