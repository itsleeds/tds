# aim: run python in docker

docker run -d -p 8787:8787 -v $(pwd):/home/rstudio/data robinlovelace/tds  
docker ps

# navigate to http://localhost:8787
# log-in with username and password rstudio
# then press Alt+Shift+T to go into the shell and enter the following
# can also be run from .sh script from the command line:
conda activate base
python

# now in python shell
import matplotlib as mpl
mpl.use('Agg')
import osmnx as ox
ox.config(use_cache=True)
G = ox.graph_from_place('Piedmont, CA, USA', network_type='drive')
# ox.plot_graph(ox.project_graph(G))
fig, ax = ox.plot_graph(ox.project_graph(G), filename = "plot", show=False, save=True, close=True)

ox.save_load.save_graph_shapefile(G, filename="graph", folder=".")
# ox.plot_graph(ox.project_graph(G), filename = "plot.png", show = False, save = True, close = True) # crashes

# then from R console:
list.files() # check graph.shp is there
library(sf)
G = st_read("graph/edges/edges.shp")
plot(G)
