import matplotlib.pyplot as plt
from array import array

Nb_var = 50
N = 1024
logN = 10
Hx1=1
alpha = 0.5



def curve_10():
	plt.yscale('linear')
	plt.xscale('linear')
	plt.xlabel('Size of the Queue', fontsize=14, color='black')
	plt.ylabel('P', fontsize=14, color='black')
	plt.title('Steady State Probability for a queue with phase type fitting parameter k')
	x = range(0,11,1)
	y_10 = [0.5000000826669286
,0.39840613145837134
,0.08095129548959867
,0.016448323368837333
,0.0033421012330050923
,6.790753730597986E-4
,1.3798015979630204E-4
,2.8033117549421624E-5
,5.682420643903797E-6
,1.1194905967466665E-6
,1.752216115764016E-7]
	y_10_2 = [0.500014
,0.309026
,0.118037
,0.0450863
,0.0172215
,0.00657809
,0.00251269
,0.000959917
,0.000367035
,0.000141172
,5.64702e-05]
	y_10_5 = [0.500001
,0.358117
,0.101622
,0.028837
,0.00818304
,0.00232209
,0.000658939
,0.000186987
,5.30691e-05
,1.51282e-05
,4.67613e-06
]
	y_10_10 = [0.5
,0.37746
,0.0925077
,0.0226717
,0.00555637
,0.00136175
,0.000333737
,8.17913e-05
,2.00432e-05
,4.92029e-06
,1.3328e-06]
	y_10_50 = [0.500008
,0.394084
,0.0834748
,0.0176817
,0.00374534
,0.000793339
,0.000168045
,3.55952e-05
,7.53877e-06
,1.59446e-06
,3.77647e-07
]
	y_10_100 = [0.499981
,0.396256
,0.0822304
,0.0170643
,0.00354115
,0.000734852
,0.000152495
,3.16453e-05
,6.56616e-06
,1.35994e-06
,3.16008e-07
]
	y_10_200 = [0.50004
,0.39729
,0.0815864
,0.0167544
,0.00344064
,0.000706561
,0.000145098
,2.97969e-05
,6.11834e-06
,1.25372e-06
,2.88498e-07
]
	plt.plot(x, y_10, label = 'k=0',linewidth=7.0)
	plt.plot(x, y_10_2, label = 'k=2')
	plt.plot(x, y_10_5, label = 'k=5')
	plt.plot(x, y_10_10, label = 'k=10')
	plt.plot(x, y_10_50, label = 'k=50')
	plt.plot(x, y_10_100, label = 'k=100')
	plt.plot(x, y_10_200, label = 'k=200')


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
	plt.plot(k, time_Jacobi_Explicit, label = 'gsmp Jacobi Explicit')
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


def main():
	()
