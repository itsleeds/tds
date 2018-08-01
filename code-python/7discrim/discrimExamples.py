import numpy as np
from pylab import *

def plot_cov_ellipse(cov, pos, volume=.5, ax=None, fc='none', ec=[0,0,0], a=1, lw=2):
    from scipy.stats import chi2
    import matplotlib.pyplot as plt
    from matplotlib.patches import Ellipse
    def eigsorted(cov):
        vals, vecs = np.linalg.eigh(cov)
        order = vals.argsort()[::-1]
        return vals[order], vecs[:,order]
    if ax is None:
        ax = plt.gca()
    vals, vecs = eigsorted(cov)
    theta = np.degrees(np.arctan2(*vecs[:,0][::-1]))
    kwrg = {'facecolor':fc, 'edgecolor':ec, 'alpha':a, 'linewidth':lw}
    # Width and height are "full" widths, not radius
    width, height = 2 * np.sqrt(chi2.ppf(volume,2)) * np.sqrt(vals)
    ellip = Ellipse(xy=pos, width=width, height=height, angle=theta, **kwrg)
    ax.add_artist(ellip)

def plot_line(gradient, intersect, xmin, xmax):
    y0 = gradient*xmin + intersect
    y1 = gradient*xmax + intersect
    plot( [xmin,xmax], [y0, y1], 'k' )


mu_p = np.array([270, 200])
mu_d = np.array([300, 150])

sigma = 250
Sigma = np.matrix([[sigma, 0], [0, sigma]])

xs_p = np.random.multivariate_normal(mu_p, Sigma, 100)
xs_d = np.random.multivariate_normal(mu_d, Sigma, 100)


clf()
plot( xs_p[:,0] , xs_p[:,1] , 'bx' )
plot( xs_d[:,0] , xs_d[:,1] , 'ro' )

xlabel("NOx")
ylabel("CO2")


#draw covarience ellipses
plot_cov_ellipse(Sigma, mu_p)
plot_cov_ellipse(Sigma, mu_d)

#TODO draw line separating (as fn of generatives?)

T = 0.0
w = np.dot (  np.linalg.inv(Sigma) , (mu_p - mu_d ) )
c = np.dot(T - np.dot(mu_p, np.linalg.inv(Sigma)), mu_p) + np.dot(np.dot(mu_p, np.linalg.inv(Sigma)), mu_p)


c=-110
g=1
plot_line(g,c, 220, 360)


import sklearn.discriminant_analysis
np.hstack (( zeros(xs_p.shape[0]) ,  ones(xs_d.shape[0])  ))

x = np.array([[-1, -1], [-2, -1], [-3, -2], [1, 1], [2, 1]])
c = np.array([1, 1, 1, 2, 2])
lda = sklearn.discriminant_analysis.LinearDiscriminantAnalysis()
lda.fit(x, c)
print(lda.predict([[-0.8, -1]]))



xs = np.vstack((xs_p, xs_d))
cs = np.hstack (( zeros(xs_p.shape[0]) ,  ones(xs_d.shape[0])  ))

#fit a decision tree 
from sklearn.tree import DecisionTreeClassifier, export_graphviz
dt = DecisionTreeClassifier(min_samples_split=20, random_state=99)
dt.fit(xs, cs)

#these lines draw a picture of the tree
#import subprocess
#export_graphviz(dt, "foo.dot", ["f","g"])
#subprocess.call("dot -Tpng foo.dot -o dt.png", shell=True)

#fit a neural network
from sklearn.neural_network import MLPClassifier
clf = MLPClassifier(solver='lbfgs', alpha=1e-5, hidden_layer_sizes=(10, 10), random_state=1)
clf.fit(xs, cs)
cs_hat_nn = clf.predict(xs)
print("ground truth:")
print(cs)
print("neural net predictions:")
print(cs_hat_nn)
#NB in real life you should use a separate test set for this to avoid overfitting.

