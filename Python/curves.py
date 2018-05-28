import matplotlib.pyplot as plt
from array import array
import sys
import numpy as np
from norm import *


#GLOBAL VARIABLE
path = '../Output/'
eps = "1E-5"
eps_precise = "1E-8"

########################################################################
###################################CURVES###############################
def curve(t,kind_of_t,engine):	
	#CONSTANT
	#n=10
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#3 	engine(string) is the engine used in computation {"explicit","hybrid"}
	if (kind_of_t=="median"):											#set the kind_of_t for naming
		subpath = 't='+str(t)+'_median/'
	else:
		subpath = 't='+str(t)+'/'
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('SSP', fontsize=14, color='black')
	plt.title('SSP\ntimeout='+str(t)+',lambda='+kind_of_t+',engine='+engine+',epsilon='+eps)

	y_0 = read_file(path+subpath+'explicit'+'/ev_10_k_'+eps_precise)	#event_model
	x = range(0,11,1)
	plt.plot(x, y_0, label = 'event model',linewidth=0.7)
	k_array = [50,1000,2000,3000,4000,5000]
	for k in k_array:
		y_k = read_file(path+subpath+engine+'/sumph_10_'+str(k)+'_'+eps)
		plt.plot(x, y_k, label = "k="+str(k),linewidth=0.7)
	plt.legend()
	plt.show()

def curve_epsilon(t,engine):	
	#CONSTANT
	#n=10
	#k
	#lambda
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#3 	engine(string) is the engine used in computation {"event","explicit","hybrid"}
	if (engine=="event"):											#set the kind_of_t for naming
		subpath = 't='+str(t)+'_median/'
	elif (engine == "explicit"):
		subpath = 't='+str(t)+'/'
	else:
		subpath = 't='+str(t)+'/'
		
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('SSP', fontsize=14, color='black')
	plt.title('SSP\ntimeout='+str(t)+',lambda='+kind_of_t+',engine='+engine+',epsilon='+eps)

	y_0 = read_file(path+subpath+'explicit'+'/ev_10_k_'+eps_precise)	#event_model
	x = range(0,11,1)
	plt.plot(x, y_0, label = 'event model',linewidth=0.7)
	eps_array = [50,1000,2000,3000,4000,5000]
	for k in k_array:
		y_k = read_file(path+subpath+engine+'/sumph_10_'+str(k)+'_'+eps)
		plt.plot(x, y_k, label = "k="+str(k),linewidth=0.7)
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
	if (kind_of_t=="median"):											#set the kind_of_t for naming
		subpath = 't='+str(t)+'_median/'
	else:
		subpath = 't='+str(t)+'/'

	states = range(0,11,1)
	k_array = read_file(path+subpath+engine+'/k_array')					#load the bottom line for explicit
	
	
	for k in k_array[0::5]:
		y_k = read_file(path+subpath+engine+'/sumph_10_'+str(int(k))+'_'+eps)
		y_0 = read_file(path+subpath+'explicit'+'/ev_10_k_'+eps)
		y = absolute(diff_array(y_0,y_k))
		plt.plot(states, y, label = "k="+str(k),linewidth=0.5)
	
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('state of the queue', fontsize=14, color='black')
	plt.ylabel('Euclidean distance for each state', fontsize=14, color='black')
	plt.title('distance of SSP for a queue versus phase type fitting parameter k\ntimeout='+str(t)+'(s),lambda='+kind_of_t+',engine='+engine)
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
