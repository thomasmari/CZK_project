import matplotlib.pyplot as plt
from array import array
import math


def read_file(filename):
	file = open(filename, "r")
	a = []
	for line in file:
	   a.append(float(line))
	return a

def diff_array(a1,a2):
	diff = []
	for i in range(0,len(a1),1):
		diff.append(a1[i]-a2[i])
	return diff

def norm2(a):
	s=0
	for e in a:
		s += e*e
	return math.sqrt(s)
	
def infinite_norm(a):
	return max(abs(a))

def absolute(a):
	ret = []
	for i in a:
		ret.append(abs(i))
	return ret

def diff_file(f1,f2):
	a1 = read_file(f1)
	a2 = read_file(f2)
	return diff_array(a1,a2)

def abs_diff_file(f1,f2):
	return absolute(diff_file(f1,f2))
		
def main():
	()
