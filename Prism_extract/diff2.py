#!/usr/bin/env python

import sys
import numpy as np

import matplotlib.pyplot as plt
from array import array



def read_file(filename):
	file = open(filename, "r")
	a = []
	for line in file:
		print line
		a.append(float(line))
	return a


def diff_array(a1,a2):
	diff = []
	for i in range(1,len(a1),1):
		diff.append(abs(a1[i]-a2[i]))
	return diff

def absolute_norm(a1,a2):
	return max(diff_array(a1,a2))
	
def infinite_norm_file(f1,f2):
	a1 = read_file(f1)
	a2 = read_file(f2)
	return absolute_norm(a1,a2)

def diff_file(f1,f2):
	a1 = read_file(f1)
	a2 = read_file(f2)
	return diff_array(a1,a2)
	
def main(f1,f2):
	return diff_file(f1,f2)

file1,file2 = sys.argv[0],sys.argv[1]
print read_file(str(file1))
