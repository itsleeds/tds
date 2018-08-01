import GPy, numpy as np
N = 5
X = np.random.uniform(-3.,3.,(N,1))
Y = np.sin(X) + np.random.randn(N,1)*0.05
kernel = GPy.kern.RBF(input_dim=1, variance=1., lengthscale=1.)
m= GPy.models.GPRegression(X,Y,kernel)
m.optimize()
m.plot()

