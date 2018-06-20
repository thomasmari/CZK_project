import matplotlib.pyplot as plt
from array import array
import sys
import numpy as np
from norm import *


#GLOBAL VARIABLE
n='10'
path = '../Output/'
eps = "1E-10"
eps_precise = "1E-15"
hybrid = 'hybrid'
storm = 'storm'
explicit = 'explicit'

########################################################################
###################################CURVES###############################
def curve(t,kind_of_t,engine):	#out of order
	#CONSTANT
	#n=10
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#3 	engine(string) is the engine used in computation {"explicit","hybrid"}
	if (kind_of_t=="median"):											#set the kind_of_t for naming
		subpath = 't='+str(t)+'_median/'
	else:
		subpath = 't='+str(t)+'_regular/'
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('SSP', fontsize=14, color='black')
	plt.title('SSP\ntimeout='+str(t)+',lambda='+kind_of_t+',engine='+engine+',epsilon='+eps)

	y_0 = read_float(path+subpath+'explicit'+'/ev_10_k_'+eps_precise)	#event_model
	x = range(0,11,1)
	plt.plot(x, y_0, label = 'event model',linewidth=0.7)
	k_array = [50,1000,2000,3000,4000,5000]
	for k in k_array:
		y_k = read_float(path+subpath+engine+'/sumph_10_'+str(k)+'_'+eps)
		plt.plot(x, y_k, label = "k="+str(k),linewidth=0.7)
	plt.legend()
	plt.show()

def curve_epsilon(t,k,engine):	
	#CONSTANT
	#n=10
	#k
	#lambda
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#3 	engine(string) is the engine used in computation {"event","explicit","hybrid"}
	if (engine=="event"):											#set the kind_of_t for naming
		subpath = 't='+str(t)+'_epsilon/explicit/'
		data = 'ev'
	elif (engine == "explicit"):
		subpath = 't='+str(t)+'_epsilon/explicit/'
		data = 'ph'
	else:
		subpath = 't='+str(t)+'_epsilon/hybrid/'
		data = 'ph'
		
	plt.yscale('log')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('SSP', fontsize=14, color='black')
	plt.title('SSP\ntimeout='+str(t)+',lambda='+'1/t, +engine='+engine+', k=50')

	#y_0 = read_float(path+subpath+'explicit'+'/ev_10_k_'+eps_precise)	#event_model
	x = range(0,11,1)
	#plt.plot(x, y_0, label = 'event model',linewidth=0.7)
	eps_array = read_file(path+subpath+data+'_eps_array')
	print eps_array
	for i,e in enumerate(eps_array[0::1]):
		if (data == 'ev'):
			y_e = read_float(path+subpath+'ev_10_k_'+str(e))
		else:
			y_e = read_float(path+subpath+'sumph_10_'+str(k)+'_'+e)
		size = 1/float(1+i)
		plt.plot(x, y_e, label = "eps="+str(e),linewidth=size)

	plt.legend()
	plt.show()


########################################################################
#############################DISTANCE PER POINT#########################

def diff_per_state(t,kind_of_t,engine,eps,kind_of_epsilon,eps_precise):	
	#CONSTANT
	#n=10
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#3 	engine(string) is the engine used in computation {"explicit","hybrid","storm"}
	#4 	epsilon "*E-*"
	#5 	kind_of_epsilon(string) in {"dynamic","constant","standart"}
	#6 	epsilon of reference "*E-*"
	
	if (kind_of_epsilon=="standart"):											#set the kind_of_t for naming
				eps="standart"

	#DATA
	if (kind_of_t=="median"):											#set the kind_of_t for naming
		subpath = 't='+str(t)+'_median'
	else:
		subpath = 't='+str(t)+'_regular'
	
	subpath_ref = subpath + ('_'+eps_precise+'_'+'constant'+'/')
	if (kind_of_epsilon=="standart"):											#set the kind_of_t for naming
		subpath += ('_standart/')
	else:
		subpath += ('_'+eps+'_'+kind_of_epsilon+'/')

	
	states = range(0,11,1)
	k_array = read_float(path+subpath+engine+'/ph_k_array')	
	k_hybrid = read_float(path+subpath+"hybrid"+'/ph_k_array')					#load the bottom line for explicit
	k_storm = read_float(path+subpath+"storm"+'/ph_k_array')					#load the bottom line for explicit
				#load the bottom line for explicit
	y_0 = read_float(path+subpath_ref+'explicit'+'/ev_10_k_'+eps_precise)
	#invisible plot for scaling
	plt.plot(states,absolute(diff_array(y_0,read_float(path+subpath+'hybrid'+'/sumph_10_'+str(int(k_hybrid[0]))+'_'+eps))),'r-', alpha=0.0,linewidth=1.5)
	plt.plot(states,absolute(diff_array(y_0,read_float(path+subpath+'hybrid'+'/sumph_10_'+str(int(k_hybrid[-1]))+'_'+eps))),'r-', alpha=0.0,linewidth=1.5)
	#~ plt.plot(states,absolute(diff_array(y_0,read_float(path+subpath+'explicit'+'/sumph_10_'+str(int(k_array[0]))+'_'+eps))),'r-', alpha=0.0,linewidth=1.5)
	#~ plt.plot(states,absolute(diff_array(y_0,read_float(path+subpath+'explicit'+'/sumph_10_'+str(int(k_array[-1]))+'_'+eps))),'r-', alpha=0.0,linewidth=1.5)
	plt.plot(states,absolute(diff_array(y_0,read_float(path+subpath+'storm'+'/ph_10_'+str(int(k_storm[-1]))+'_'+eps))),'r-', alpha=0.0,linewidth=1.5)
	plt.plot(states,absolute(diff_array(y_0,read_float(path+subpath+'storm'+'/ph_10_'+str(int(k_storm[-1]))+'_'+eps))),'r-', alpha=0.0,linewidth=1.5)


	#real plotting
	for k in k_array[0::4]: #1 curve on 4
		if (engine=="storm"):
			if (kind_of_epsilon=="standart"):											#set the kind_of_t for naming
				y_k = read_float(path+subpath+engine+'/ph_10_'+str(int(k))+'_standart')
			else:
				y_k = read_float(path+subpath+engine+'/ph_10_'+str(int(k))+'_'+eps)
		else:
			if (kind_of_epsilon=="standart"):											#set the kind_of_t for naming
				y_k = read_float(path+subpath+engine+'/sumph_10_'+str(int(k))+'_standart')
			else:
				y_k = read_float(path+subpath+engine+'/sumph_10_'+str(int(k))+'_'+eps)			
		y = absolute(diff_array(y_0,y_k))
		plt.plot(states, y, label = "k="+str(k),linewidth=0.5)
	
	plt.yscale('log')
	plt.xscale('linear')
	plt.xlabel('State of the queue', fontsize=14, color='black')
	plt.ylabel('difference', fontsize=14, color='black')
	plt.xlim(0, 10)
	plt.ylim(0, y_k[-1])
	plt.gca().set_aspect('equal', adjustable='box')
	plt.title('absolute difference between Phase Type Fitting\'s SSP and Event Model\'s SSP \ntimeout='+str(t)+'(s),lambda='+kind_of_t+',\nengine='+engine+',epsilon='+eps+','+kind_of_epsilon+' epsilon, ref = '+eps_precise,fontsize=11)
	plt.legend()
	plt.show()	

########################################################################
#############################DISTANCE (NORM)############################

def distance_k(t,kind_of_t,norm,eps,kind_of_epsilon,eps_precise):	
	#CONSTANT
	#n=10
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#3 	norm(string) is how the norm that must be use for defining the distance {"norm_2","norm_infinite"}
	#4 	epsilon "*E-*" or "standart"
	#5 	kind_of_epsilon(string) in {"dynamic","constant","standart"}
	#6 	epsilon of reference "*E-*"
	
	if (kind_of_epsilon=="standart"):
		eps = "1E-6"

	if (kind_of_t=="median"):											#set the kind_of_t for naming
		subpath1 = 't='+str(t)+'_median_'
		subpath_ref = 't='+str(t)+'_median_'
	else:
		subpath1 = 't='+str(t)+'_regular_'
		subpath_ref = 't='+str(t)+'_regular_'
	
	if (kind_of_epsilon=="standart"):											#set the kind_of_t for naming
		subpath2 = subpath1+'standart/'
	else:
		subpath2 = subpath1 + eps+'_'+kind_of_epsilon+'/'
	subpath_ref += eps_precise+'_'+"constant"+'/'
	#EVENT
	engine = "explicit/"
	full_path = path+subpath1+eps+'_'+'constant/'+explicit+'/'										#set the engine for naming
	full_path_ref = path+subpath_ref+explicit+'/'										#set the engine for naming
	y_ref = read_float(full_path_ref+'ev_'+n+'_k_'+eps_precise) 	#this is the reference distribution (event and precise)
	y_event = read_float(full_path+'ev_'+n+'_k_'+eps) 			#this is the event distribution
	if (norm == "norm_2"):
		result_event = norm_2(diff_array(y_ref,y_event))
	else:
		result_event = norm_infinite(diff_array(y_ref,y_event))
	
	#~ #EXPLICIT
	#~ k_explicit = read_float(full_path+'ph_k_array')					#load the bottom line for explicit
	#~ result_explicit = np.array([])											
	#~ for k in k_explicit:
		#~ y_k = read_float(full_path+'sumph_'+n+'_'+str(int(k))+'_'+eps)
		#~ if (norm == "norm_2"):
			#~ result = norm_2(diff_array(y_ref,y_k))
		#~ else:
			#~ result = norm_infinite(diff_array(y_ref,y_k))
		#~ result_explicit = np.append(result_explicit, [result], axis=0)
	
	#HYBRID
	engine = "explicit/"
	full_path = path+subpath2+hybrid+'/'	
	
	k_hybrid = read_float(full_path+'ph_k_array')					#load the bottom line for explicit
	result_hybrid = np.array([])											
	for k in k_hybrid:
		if (kind_of_epsilon=="standart"):											#set the kind_of_t for naming
			y_k = read_float(full_path+'sumph_'+n+'_'+str(int(k))+'_standart')
		else:
			y_k = read_float(full_path+'sumph_'+n+'_'+str(int(k))+'_'+eps)
		
		if (norm == "norm_2"):
			result = norm_2(diff_array(y_event,y_k))
		else:
			result = norm_infinite(diff_array(y_event,y_k))
		result_hybrid = np.append(result_hybrid, [result], axis=0)

	#STORM
	engine = "storm/"
	full_path = path+subpath2+storm+'/'	
	
	k_storm = read_float(full_path+'ph_k_array')					#load the bottom line for explicit
	result_storm = np.array([])											
	for k in k_storm:
		if (kind_of_epsilon=="standart"):											#set the kind_of_t for naming
			y_k = read_float(full_path+'ph_'+n+'_'+str(int(k))+'_standart')
		else:
			y_k = read_float(full_path+'ph_'+n+'_'+str(int(k))+'_'+eps)

		if (norm == "norm_2"):
			result = norm_2(diff_array(y_event,y_k))
		else:
			result = norm_infinite(diff_array(y_event,y_k))
		result_storm = np.append(result_storm, [result], axis=0)
				
	#PLOTING
	plt.yscale('log')
	plt.xscale('log')
	plt.xlabel('PTF parameter k', fontsize=14, color='black')
	plt.ylabel('distance', fontsize=14, color='black')
	if (norm=="infinite"):
		plt.title('Infinity norm distance of SSP for a queue versus PH fitting parameter k\ntimeout='+str(t)+','+kind_of_t+' lambda, eps ='+eps+', eps ref='+eps_precise+','+kind_of_epsilon+' epsilon')
	else:
		plt.title('Euclidean distance of SSP for a queue versus phase type fitting parameter k\ntimeout='+str(t)+','+kind_of_t+' lambda, eps ='+eps+', eps ref='+eps_precise)
	plt.plot(k_hybrid, result_hybrid, label = "hybrid",linewidth=0.5)
	#~ plt.plot(k_explicit, result_explicit, label = "explicit",linewidth=0.5)
	plt.plot(k_storm, result_storm, label = "storm -sparse",linewidth=0.5)
	plt.plot(k_storm, [result_event]*len(k_storm), label = "event",linewidth=0.5)


	plt.legend()
	plt.show()
	
	
def distance_plot_epsilon(t,k,norm):	
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	k the PTF parameters
	#3 	norm(string) is how the norm that must be use for defining the distance {"norm_2","norm_infinite"}

	#CONSTANT
	n="10"
	
	#DATA												
	subpath = 't='+str(t)+'_epsilon/'

	#EVENT
	engine = "explicit/"												#set the engine for naming
	y_event = read_float(path+subpath+engine+'ev_'+n+'_k_'+eps_precise) 	#this is the reference distribution
	#EXPLICIT
	eps_explicit = read_file(path+subpath+engine+'ph_eps_array')						#load the bottom line for explicit
	result_explicit = []											
	for e in eps_explicit:
		y_e = read_float(path+subpath+engine+'sumph_'+n+'_'+str(int(k))+'_'+str(e))
		if (norm == "norm_2"):
			result = norm_2(diff_array(y_event,y_e))
		else:
			result = norm_infinite(diff_array(y_event,y_e))
		result_explicit += [result]
	#HYBRID
	engine = "hybrid/"													#set the naming for naming
	eps_hybrid = read_file(path+subpath+engine+'ph_eps_array')						#load the bottom line for explicit
	result_hybrid = []
	print len(result_hybrid)	
	for e in eps_hybrid:
		y_e = read_float(path+subpath+engine+'sumph_'+n+'_'+str(int(k))+'_'+e)
		if (norm == "norm_2"):
			result = norm_2(diff_array(y_event,y_e))
		else:
			result = norm_infinite(diff_array(y_event,y_e))
		result_hybrid += [result]
		print result_hybrid
	#PLOTING
	plt.yscale('log')
	plt.xscale('log')
	plt.xlabel('epsilon termination', fontsize=14, color='black')
	plt.ylabel('distance', fontsize=14, color='black')
	if (norm=="infinite"):
		plt.title('Maximum distance between event model eps = 1E-13 and PTF k=1000 for engine explicit and hybrid')
	else:
		plt.title('Euclidean distance between event model eps = 1E-13 and PTF k=1000 for engine explicit and hybrid')
	plt.plot(map(float,eps_hybrid), result_hybrid, label = "hybrid",linewidth=0.5)
	plt.plot(map(float,eps_explicit), result_explicit, label = "explicit",linewidth=0.5)
	plt.legend()
	plt.show()
	

def performance(t,kind_of_t,eps,kind_of_epsilon):
	#CONSTANT
	#n=10
	#PARAMETERS : 
	#1 	t(float) is the timeout in sec
	#2 	kind_of_t(string) is how t was choosen in {"regular","median"} according to lambda
	#5 	kind_of_epsilon(string) in {"dynamic","constant"}
	#4 	epsilon "*E-*"
	#5 	kind_of_epsilon(string) in {"dynamic","constant"}
	#6 	epsilon of reference "*E-*"

	#CONSTANT
	n="10"
	
	#PATH SETTING
	if (kind_of_t=="median"):											#set the kind_of_t for naming
		subpath = 't='+str(t)+'_median_'+eps+'_'+kind_of_epsilon+'/'
	else:
		subpath = 't='+str(t)+'_regular_'+eps+'_'+kind_of_epsilon+'/'	

	#EXPLICIT	
	#~ full_path = path+subpath+"explicit/"
		
	#~ y_event = read_float(full_path+'ev_time_10')
	#~ y_explicit = read_float(full_path+'ph_time_10')
	#~ k_explicit = read_float(full_path+'ph_k_array')
	
	#HYBRID
	full_path = path+subpath+"hybrid/"

	y_hybrid = read_float(full_path+'ph_time_10')
	k_hybrid = read_float(full_path+'ph_k_array')

	#Storm
	full_path = path+subpath+"storm/"

	y_storm = read_float(full_path+'ph_time_10')
	k_storm = read_float(full_path+'ph_k_array')
	
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
	plt.title('Time of computation of the SSP versus k the PTF parameter\n epsilon = '+eps+', '+kind_of_epsilon+' epsilon, t='+str(t)+', '+kind_of_t,fontsize=11)
	
	plt.plot(k_array, y_event[0:1:1]*len(k_storm), label = 'event',linewidth=1.0)
	#~ plt.plot(k_explicit, y_explicit, label = 'explicit',linewidth=1.0)
	plt.plot(k_hybrid, y_hybrid, label = 'hybrid',linewidth=1.0)
	plt.plot(k_storm, y_storm, label = 'storm -sparse',linewidth=1.0)
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
