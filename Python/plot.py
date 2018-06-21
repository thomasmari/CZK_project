import matplotlib.pyplot as plt
from array import array
import sys
import numpy as np
from norm import *
from curves import *

for eps in ["1E-5","1E-6","1E-10"]:
	performance(0.1,"median",eps,"constant")
	performance(0.1,"median",eps,"dynamic")
	distance_k(0.1,"median","infinite",eps,"constant","1E-20")
	distance_k(0.1,"median","infinite",eps,"dynamic","1E-20")
	diff_per_state(0.1,"median","hybrid",eps,"constant","1E-20")
	diff_per_state(0.1,"median","hybrid",eps,"dynamic","1E-20")
	diff_per_state(0.1,"median","storm",eps,"constant","1E-20")
	diff_per_state(0.1,"median","storm",eps,"dynamic","1E-20")

def main():
	()
