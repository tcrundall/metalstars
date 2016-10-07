import numpy as np
import matplotlib.pyplot as plt

def f(x):
	return x**3

def xi(m):
	if m < 1:
		return np.exp(-(np.log(m) - np.log(0.22))**2/(2*0.52**2))
	if m >= 1:
		return np.exp(-(-np.log(0.22))**2/(2*0.52**2))*m - 1.35

if (False):
	x1 = np.linspace(-10,10,101)
	x2 = np.linspace(-5,5,101)
	
	#plt.plot(x1,f(x1))
	#plt.fill_between(x2, f(x2))
	#plt.show()

if (False):
	x1 = np.linspace(-2,2,100)
	y2 = np.array([xi(m) for m in x1])
	plt.plot(x1,y2)
	plt.show()


def f1(x):
	if type(x) is np.ndarray:
		print("{}: Still an array".format(x[0]))
	else:
		print("{}: not an array".format(x))
	return x**2

x7 = np.linspace(0,10,11)

print(f1(x7))

x1 = np.linspace(0,2,1000)

def dndlogm(m):
	if (m < 1):
		return np.exp(-(np.log10(m) - np.log10(0.22))**2/(2*0.57**2))

	if (m >= 1):
		return np.exp(-(-np.log10(0.22))**2/(2*0.57**2))*m**(-1.35)

y1 = np.array([dndlogm(x) for x in x1])

if(True):
	plt.plot(x1,y1)
	ms = np.where(x1 < 0.075)
	plt.fill_between(x1[ms],y1[ms])
	plt.title("Proportion of stars at each mass")
	plt.xlabel(r"Mass $M_{\odot}$")
	plt.ylabel("Un-normalised number of stars")
	plt.savefig("Browndwarfs.eps")
	plt.show()

from scipy.integrate import quad

M_bd = 0.075
M_max = 100.0
M_min = 0.0
print(quad(dndlogm, M_min, M_bd))
print(quad(dndlogm, M_min, M_max))

print(quad(dndlogm, M_min, M_bd)[0]/quad(dndlogm, M_min, M_max)[0])
