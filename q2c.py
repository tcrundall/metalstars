import numpy as np
from scipy.special import erfc
from scipy.optimize import brentq
import matplotlib.pyplot as plt

def fraction(n_mean, mach_n):
	n_min = 2.53e6
	disp_sq = np.log(1.0 + mach_n**2/4.)
	return 0.5*erfc( (np.log(n_min / n_mean) - disp_sq*0.5) / np.sqrt(2*disp_sq))

def equation(mach_n, n_mean, F_bd):
	return fraction(n_mean, mach_n) - F_bd

def get_mach(n_mean, F_bd):
	result =  brentq(equation, 1e-3, 100, args=(n_mean, F_bd))
	return result
	
def main():
	n_means = np.linspace(1e4, 1e6, 1000)
	F_bd = 0.01471
	M1 = np.array([get_mach(n_mean, F_bd) for n_mean in n_means])
	plt.plot(n_means, M1)
	plt.xscale('log')
	plt.fill_between(n_means, M1)
	plt.plot([5e4],[7], 'go')
	plt.text(4.5e4, 7.2, 'IC 348')
	plt.xlabel(r'$\overline{n}$')
	plt.ylabel(r'$\mathcal{M}$')
	plt.savefig('q2c.eps')
	plt.show()

main()
