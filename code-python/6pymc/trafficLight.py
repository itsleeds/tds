#!/usr/bin/python3

# import libraries
import pymc3 as pm
from scipy import stats
import matplotlib.pyplot as plt

# this is PyMC3 notation
# essentially model initialisation in PyMC3 is done into the model fitting portion of the 
# code and there is no model building as in PyMC2

with pm.Model() as trafficLight_model:

	# define our data - PyMC3 does not like map objects
	data = stats.bernoulli(0.2).rvs(100000)
	
	# similar as in PyMC2 
	theta = pm.Beta("theta", alpha=1.0 , beta=1.0)
	# "observed" replaces "value" 
	color = pm.Bernoulli("color", p=theta, observed=data)
	
	# define iteration start
	start = pm.find_MAP()
    
    # MCMC in PyMC3
	step = pm.Metropolis()
	trace=pm.sample(1e4, start=start, step = step, model=trafficLight_model)
 
# show our amazing results   
pm.traceplot(trace[0:]);
plt.show()