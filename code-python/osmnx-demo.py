# Aim: demonstrat osmnx in action

place = "Dangkao"

import networkx as nx
import osmnx as ox
import requests
import matplotlib.cm as cm
import matplotlib.colors as colors
# after fixing a couple of issues, e.g. with https://github.com/gboeing/osmnx/issues/45 and:
# Error in py_call_impl(callable, dots$args, dots$keywords) : 
#   ImportError: Something is wrong with the numpy installation. While importing we detected an older version of numpy in ['/home/robin/.local/lib/python3.6/site-packages/numpy']. One method of fixing this is to repeatedly uninstall numpy until none is found, then reinstall this version. 
# ... I can do this:
G = ox.graph_from_place(place, network_type='drive')
ox.plot_graph(ox.project_graph(G)) # note this was sloooow!
