import ogr     #use the low level OGR library
from pylab import *

#in this example we access fields and print them
ds = ogr.Open("/headless/data/dcc/examples/BluetoothUnits.shp")
layer = ds.GetLayer(0) #shapefiles may have multiple layers
ldefn = layer.GetLayerDefn()
#loop over each feature NAME in the layer DEFINITION
for n in range(ldefn.GetFieldCount()):
    featurename = ldefn.GetFieldDefn(n).name
    print(featurename)
for feature in layer: #loop over each object in the layer
    location_description = feature.GetField("Location")
    print(location_description)
