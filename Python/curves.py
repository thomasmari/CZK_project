import matplotlib.pyplot as plt
from array import array
import sys
import numpy as np
from norm import *


#GLOBAL VARIABLE
path = '../Output/'
eps = "1E-5"
eps_precise = "1E-8"

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
	
def curve01():	
	#t=0.1
	#lambda=1/t
	#n=10

	
	subpath = 't=0.1/'
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('P', fontsize=14, color='black')
	plt.title('Steady State Probability for a queue with phase type fitting parameter k')
	x = range(0,11,1)
	k_array = [1, 2, 5, 25, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 400, 1000, 2000]
	#hybrid
	for k in k_array:
		y_k = read_file(path+subpath+'hybrid/sumph_10_'+str(k))
		plt.plot(x, y_k, label = "k="+str(k),linewidth=0.5)
	plt.legend()
	plt.show()


	subpath = 't=0.1/'
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('Euclidean distance per size', fontsize=14, color='black')
	plt.title('distance of SSP for a queue versus phase type fitting parameter k\ntimeout=0.1,lambda=1/timeout,engine=hybrid')
	x = range(0,11,1)
	k_array = [1, 2, 5, 25, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 400, 1000, 2000]
	#hybrid
	for k in k_array:
		y_k = read_file(path+subpath+'hybrid/sumph_10_'+str(k))
		y_0 = read_file(path+subpath+'ev_10')
		y = absolute(diff_array(y_0,y_k))
		plt.plot(x, y, label = "k="+str(k),linewidth=0.5)
	plt.legend()
	plt.show()


########################################################################
#############################DISTANCE PER POINT#########################

def distance_per_state(t,kind_of_t,norm,engine):	
	#CONSTANT
	#n=10
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#3 	norm(string) is how the norm that must be use for defining the distance {"norm_2","norm_infinite"}
	#4 	engine(string) is the engine used in computation {"explicit","hybrid"}
	
	#DATA
	if (kind_of_t=="median"):												#set the kind_of_t for naming
		subpath = 't='+str(t)+'_median/'
	else:
		subpath = 't='+str(t)+'/'

	states = range(0,11,1)
	k_explicit = read_file(path+subpath+engine+'k_array')						#load the bottom line for explicit
	
	
	for k in k_array:
		y_k = read_file(path+subpath+'explicit/sumph_10_'+str(k))
		y_0 = read_file(path+subpath+'ev_10')
		y = absolute(diff_array(y_0,y_k))
		plt.plot(states, y, label = "k="+str(k),linewidth=0.5)
	
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('Euclidean distance per size', fontsize=14, color='black')
	plt.title('distance of SSP for a queue versus phase type fitting parameter k\ntimeout=0.001,lambda=1/timeout,engine=explicit')
	plt.legend()
	plt.show()	

########################################################################
#############################DISTANCE (NORM)############################

def distance_plot(t,kind_of_t,norm):	
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#3 	norm(string) is how the norm that must be use for defining the distance {"norm_2","norm_infinite"}

	#CONSTANT
	n="10"
	
	#DATA
	if (kind_of_t=="median"):												#set the kind_of_t for naming
		subpath = 't='+str(t)+'_median/'
	else:
		subpath = 't='+str(t)+'/'
	#EVENT
	engine = "explicit/"												#set the engine for naming
	y_event = read_file(path+subpath+engine+'ev_'+n+'_k_'+eps_precise) 	#this is the reference distribution
	#EXPLICIT
	k_explicit = read_file(path+subpath+engine+'k_array')						#load the bottom line for explicit
	result_explicit = np.array([])											
	for k in k_explicit:
		y_k = read_file(path+subpath+engine+'sumph_'+n+'_'+str(int(k))+'_'+eps)
		if (norm == "norm_2"):
			result = norm_2(diff_array(y_event,y_k))
		else:
			result = norm_infinite(diff_array(y_event,y_k))
		result_explicit = np.append(result_explicit, [result], axis=0)
	#HYBRID
	engine = "hybrid/"													#set the naming for naming
	if (kind_of_t=="median"):												#set the_kind_of_t for naming
		subpath = 't='+str(t)+'_median/'
	else:
		subpath = 't='+str(t)+'/'
		
	k_hybrid = read_file(path+subpath+engine+'k_array')						#load the bottom line for explicit
	result_hybrid = np.array([])	
	for k in k_hybrid:
		y_k = read_file(path+subpath+engine+'sumph_'+n+'_'+str(int(k))+'_'+eps)
		if (norm == "norm_2"):
			result = norm_2(diff_array(y_event,y_k))
		else:
			result = norm_infinite(diff_array(y_event,y_k))
		result_hybrid = np.append(result_hybrid, [result], axis=0)
			
	#PLOTING
	plt.yscale('log')
	plt.xscale('log')
	plt.xlabel('PTF parameter k', fontsize=14, color='black')
	plt.ylabel('Euclidean distance per distribution', fontsize=14, color='black')
	plt.title('distance of SSP for a queue versus phase type fitting parameter k\ntimeout=0.1,lambda=1/timeout,engine=explicit')
	plt.plot(k_hybrid, result_hybrid, label = "hybrid",linewidth=0.5)
	plt.plot(k_explicit, result_explicit, label = "explicit",linewidth=0.5)
	plt.legend()
	plt.show()
	

def performance(t,kind_of_t):
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda

	#CONSTANT
	n="10"
	

	#EXPLICIT	
	engine = "explicit/"
	if (kind_of_t=="median"):
		subpath = 't='+str(t)+'_median/'+engine
	else:
		subpath = 't='+str(t)+'/'+engine
	
	y_event = read_file(path+subpath+'evtime_10_'+eps)
	y_explicit = read_file(path+subpath+'phtime_10_'+eps)
	k_explicit = read_file(path+subpath+'k_array')
	
	#HYBRID
	engine = "hybrid/"
	if (kind_of_t=="median"):
		subpath = 't='+str(t)+'_median/'+engine
	else:
		subpath = 't='+str(t)+'/'+engine
	y_hybrid = read_file(path+subpath+'phtime_10_'+eps)
	k_hybrid = read_file(path+subpath+'k_array')
	
	#DATA
	if (len(k_hybrid)>len(k_explicit)):
		k_array = k_hybrid
		max_length = len(k_hybrid)
	else:
		k_array = k_explicit
		max_length = len(k_explicit)
		
	
	#PLOTING
	plt.yscale('log')
	plt.xscale('log')
	plt.xlabel('K Phase Type Fitting Parameter', fontsize=14, color='black')
	plt.ylabel('Time of Computation (s)', fontsize=14, color='black')
	plt.title('Time of computation of the Steady States Probabilities versus k the PTF parameter')
	
	plt.plot(k_array, y_event*len(k_array), label = 'event',linewidth=1.0)
	plt.plot(k_explicit, y_explicit, label = 'explicit',linewidth=1.0)
	plt.plot(k_hybrid, y_hybrid, label = 'hybrid',linewidth=1.0)
	plt.legend()
	plt.show()


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
