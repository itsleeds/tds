import GPy, numpy as np 
#generate some data
X = np.random.uniform(-3.,3.,(50,2))
Y = np.sin(X[:,0:1]) * np.sin(X[:,1:2])+np.random.randn(50,1)*0.05
#define, fit and plot 2D Gaussian Process
ker = GPy.kern.Matern52(2,ARD=True) + GPy.kern.White(2)
m = GPy.models.GPRegression(X,Y,ker)
m.optimize(messages=True,max_f_eval = 1000)
m.plot()
#plot uncertinties of three 1D slices through the 2D surface
slices = [-1, 0, 1.5]
figure = GPy.plotting.plotting_library().figure(3, 1)
for i, y in zip(range(3), slices):
        m.plot(figure=figure, fixed_inputs=[(1,y)], row=(i+1), plot_data=False)

