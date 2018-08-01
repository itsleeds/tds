#!/usr/bin/python3

#sudo pip3 install graphviz
#sudo pip3 install pydot

# import necessary libraries
import pymc3 as pm
import numpy as np
import theano.tensor as t
import theano
from theano.printing import pydotprint
import matplotlib.pyplot as plt
			
# PyMC3 notation	
with pm.Model() as inferAccidents_Model:
	
	# generate our data
	data=np.array([ 4, 5, 4, 0, 1, 4, 3, 4, 0, 6, 3, 3, 4, 0, 2, 6, 3, 3, 5, 4, 5, 3, 1, 4, 
				4, 1, 5, 5, 3, 4, 2, 5, 2, 2, 3, 4, 2, 1, 3, 2, 2, 1, 1, 1, 1, 3, 0, 0, 1, 
				0, 1, 1, 0, 0, 3, 1, 0, 3, 2, 2, 0, 1, 1, 1,0, 1, 0, 1, 0, 0, 0, 2, 1, 0, 
				0, 0, 1, 1, 0, 3, 3, 1, 1, 2, 1, 1, 1, 1, 2, 4, 2, 0, 0, 1, 4, 0, 0, 0, 1, 
				0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1])
				
	# no need to have "beta" in Exponential parameters
	switchpoint = pm.DiscreteUniform('switchpoint', lower=0, upper=110)
	early_mean = pm.Exponential('early_mean', 1.0)
	late_mean = pm.Exponential('late_mean', 1.0)
	
	# define custom, deterministic distribution
	# we need to do it with theano
	# similar notation to PyMC2 can be used for simple distributions
	@theano.compile.ops.as_op(itypes=[t.lscalar, t.dscalar,t.dscalar],otypes=[t.dvector])
	def rate(switchpoint, early_mean, late_mean):
		out=np.empty(len(data))
		out[:switchpoint] = early_mean
		out[switchpoint:] = late_mean
		return out.flatten()
	
	# need to explicitly define inputs for "rate" to run
	accidents = pm.Poisson('accidents', mu=rate(switchpoint, early_mean, late_mean), observed=data)
	
	# no support for dag in PyMC3
	# we do it with theano instead
	# install pydotprint for python 3: ' pip3 install pydotprint '
	# install graphviz
	# pydotprint(inferAccidents_Model.logpt)
	
	# define iteration start
	start = pm.find_MAP()
	
	# MCMC in PyMC3
	step = pm.Metropolis()
	trace=pm.sample(1e4, start=start, step = step, model=inferAccidents_Model)
	
# show our amazing results   
pm.traceplot(trace[0:]);
plt.show()
